//
//  ProfileViewController.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 08.10.2020.
//

import UIKit
import Firebase
import FirebaseStorage
import Kingfisher

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // MARK: - IB Outlet
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameAndSurnameLabel: UILabel!
    @IBOutlet var exitButton: UIButton!
    
    @IBOutlet var addProfilePhotoBarButton: UIBarButtonItem!
    @IBOutlet var addProfileNameBarButton: UIBarButtonItem!
    
    @IBOutlet var recipiesCollectionView: UICollectionView!
    let imagePicker = UIImagePickerController()
    
    var user: User!
    var ref: DatabaseReference!
    var imageRef: DatabaseReference!
    var storageProfileImagesRef: StorageReference!

    var name: String!
    var surName: String!
    var image: UIImage!
    var timer: Timer?
    var recipies = ["1", "2", "3", "4", "5"]
    
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        
        recipiesCollectionView.layer.shadowColor = CGColor(red: 93, green: 83, blue: 230, alpha: 1)
        recipiesCollectionView.layer.shadowRadius = 6
        recipiesCollectionView.layer.shadowOpacity = 1
        imagePicker.delegate = self
        startTimer()
        downloadImageProfile()
        checkCurrentUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        FirebaseService.firebaseObserverProfile(ref: ref) { [weak self] (profile) in
            self?.userNameAndSurnameLabel.text = profile.surName.capitalized + " " + profile.name.capitalized
        }
    }
    
    override func viewWillLayoutSubviews() {
        userImageView.layer.cornerRadius = userImageView.frame.width / 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "seeRecipe", for: indexPath) as! ProfileCollectionViewCellRecipe
        
        let recipe = recipies[indexPath.item % recipies.count]
        cell.imageRecipeImageView.image = UIImage(named: recipe)
        cell.imageRecipeImageView.layer.cornerRadius = 30
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goRecipeProfile", sender: nil)
    }
    
    // MARK: - IB Actions
    
    func downloadImageProfile() {
        if image != nil {
            userImageView.image = image
        }
    }
    
    @IBAction func signOut(_ sender: UIButton) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addPhoto(_ sender: UIBarButtonItem) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func editNameAndSurName(_ sender: UIBarButtonItem) {
        showAlert(title: "Your profile", message: "Enter your name and surname")
    }
}

extension ProfileViewController {
    
    // MARK: - UIAllert
    private func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Surname"
        }
        let save = UIAlertAction(title: "Save", style: .default) { [weak self] (_) in
            guard let textFieldOne = alertController.textFields?.first, textFieldOne.text != "" else { return }
            guard let textFieldTwo = alertController.textFields?.last, textFieldTwo.text != "" else { return }
            
            let profileName = Profile(name: textFieldOne.text!, surName: textFieldTwo.text!, userId: (self?.user.uid)!)
            let taskRef = self?.ref.child("Name and Surname")
            taskRef!.setValue(profileName.convertToDictionary())
        }
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(save)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - FireBase Auth
    func checkCurrentUser() {
        guard let currentUser = Auth.auth().currentUser else { return  }
        user = User(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("profile")
        imageRef = Database.database().reference(withPath: "users").child(String(self.user.uid)).child("imageProfile")
        storageProfileImagesRef = Storage.storage().reference().child(user!.uid)
    }
    
    // MARK: - ImagePicker(Photo Gallery) & FireBase Storage
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            userImageView.contentMode = .scaleAspectFill
            userImageView.image = image
            
            //Firebase Upload Imagw
            guard let data = image.jpegData(compressionQuality: 0.1) else { return }
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpeg"
            storageProfileImagesRef.putData(data, metadata: metadata) { [weak self] (metadata, _) in
                guard let _ = metadata else { return }
                self?.storageProfileImagesRef.downloadURL { [weak self] (url, _) in
                    guard let url = url else { return }
                    self?.imageRef.setValue(["image" : url.absoluteString])
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
    // MARK: - UICollectionView
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemsPerRow: CGFloat = 1
        let paddingWidth = 20 * (itemsPerRow + 1)
        let aviableWidth = collectionView.frame.height - paddingWidth
        let widthPerItem = aviableWidth / itemsPerRow
        return CGSize(width: collectionView.frame.width - 40, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        40
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
    @objc func autoScroll() {
            guard let currentItemNumber = recipiesCollectionView.indexPathsForVisibleItems.first?.item  else { return }
            let nextItemNumber = currentItemNumber + 1
            let nextIndexPath = IndexPath(item: nextItemNumber, section: 0)
        recipiesCollectionView.scrollToItem(at: nextIndexPath, at: .left, animated: true)
        }

        func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
            stopTimer()
        }
        func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
            startTimer()
        }

        func startTimer() {
            timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(autoScroll), userInfo: nil, repeats: true)
        }

        func stopTimer() {
            timer?.invalidate()
            timer = nil
        }
}

