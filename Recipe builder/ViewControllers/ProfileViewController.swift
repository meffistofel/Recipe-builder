//
//  ProfileViewController.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 08.10.2020.
//

import UIKit
import Firebase

protocol fullyName {
}

class ProfileViewController: UIViewController {
    
    // MARK: - IB Outlet
    @IBOutlet var userImageView: UIImageView!
    @IBOutlet var userNameAndSurnameLabel: UILabel!
    @IBOutlet var editPhotoLAbel: UIButton!
    
    var user: User!
    var ref: DatabaseReference!
    
    var name: String!
    var surName: String!
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkCurrentUser()
    }
    
    // MARK: - IB Actions
    @IBAction func signOut(_ sender: UIButton) {
        do {
            try FirebaseAuth.Auth.auth().signOut()
        } catch {
            print(error.localizedDescription)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editPhoto(_ sender: UIButton) {
    }
    
    @IBAction func editNameAndSurName(_ sender: UIBarButtonItem) {
        showAlert(title: "Your profile", message: "Enter your name and surname")
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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
        let save = UIAlertAction(title: "Save", style: .default) { (_) in
            guard let textFieldOne = alertController.textFields?.first, textFieldOne.text != "" else { return }
            guard let textFieldTwo = alertController.textFields?.last, textFieldTwo.text != "" else { return }
            
            let profileName = Profile(name: textFieldOne.text, surName: textFieldTwo.text, userId: <#T##String#>)
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
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("recipiesFromFavourite")
    }
}
