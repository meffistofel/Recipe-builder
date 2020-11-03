//
//  TypeRecipiesViewController.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 13.10.2020.
//

import UIKit
import Firebase


class TypeRecipiesViewController: UICollectionViewController {
    
    // MARK: - Let & Var
    var typeRecipies = TypeRecipies.getTypeRecipie()
    
    private let recipiesURLChiken = "https://api.edamam.com/search?q=chicken"
    private let recipiesURLMeat = "https://api.edamam.com/search?q=meat"
    private let recipiesURLMilk = "https://api.edamam.com/search?q=milk"
    private let recipiesURLFish = "https://api.edamam.com/search?q=fish"

    private var ref: DatabaseReference!
    private var user: User!
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkCurrentUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let navController = self.tabBarController!.viewControllers![2] as! UINavigationController
        let vc = navController.topViewController as? ProfileViewController
        
        FirebaseService.firebaseObserverProfile(ref: ref) { (profile) in
            vc?.nameAndSurname = profile.name + "" + profile.surName
        }
        
        let storageProfileImagesRef = Storage.storage().reference().child(user!.uid)
        let megaByte = Int64(1 * 1024 * 1024)
        storageProfileImagesRef.getData(maxSize: megaByte) { (data, error) in
            let imageData = data
            if imageData != nil {
                guard let image = UIImage(data: imageData!) else { return }
                vc?.profileImage = image
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return typeRecipies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "blockRecipies", for: indexPath) as! TypeRecipiesViewCell
        
        let recipe = typeRecipies[indexPath.item]
        cell.configure(with: recipe)
        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let recipiesTVC = segue.destination as! RecipeViewController
        switch segue.identifier {
        case "goRecipiesChiken": recipiesTVC.fetchRecipies(url: recipiesURLChiken)
        case "goRecipiesMeat": recipiesTVC.fetchRecipies(url: recipiesURLMeat)
        case "goRecipiesMilk": recipiesTVC.fetchRecipies(url: recipiesURLMilk)
        case "goRecipiesFish": recipiesTVC.fetchRecipies(url: recipiesURLFish)
        default: break
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = typeRecipies[indexPath.item]
        switch item.nameImageRecipies {
        case "Chicken": performSegue(withIdentifier: "goRecipiesChiken", sender: nil)
        case "Meat": performSegue(withIdentifier: "goRecipiesMeat", sender: nil)
        case "Milk": performSegue(withIdentifier: "goRecipiesMilk", sender: nil)
        case "Fish": performSegue(withIdentifier: "goRecipiesFish", sender: nil)
        default: break
        }
    }
    
    func checkCurrentUser() {
        guard let currentUser = Auth.auth().currentUser else { return  }
        user = User(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("profile")
    }
}

