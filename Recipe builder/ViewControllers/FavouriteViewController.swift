//
//  FavouriteViewController.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 19.10.2020.
//

import UIKit
import Firebase

class FavouriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var user: User!
    var ref: DatabaseReference!
    var recipiesFromFavourite = [Recipies]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        checkCurrentUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ref.observe(.value) { [weak self] (snapshot) in
            var recipiesFavourite = [Recipies]()
            for item in snapshot.children {
                let recipe = Recipies(snapShot: item as! DataSnapshot)
                recipiesFavourite.append(recipe)
            }
            self?.recipiesFromFavourite = recipiesFavourite
            self?.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipiesFromFavourite.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favourite", for: indexPath) as! FavouriteTableViewCell
        
        let favouriteRecipe = recipiesFromFavourite[indexPath.row]
        cell.configure(recipe: favouriteRecipe)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recipe = recipiesFromFavourite[indexPath.row]
            recipe.ref?.removeValue()
            
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let recipe = recipiesFromFavourite[indexPath.row]
        performSegue(withIdentifier: "favouriteDescription", sender: recipe)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let favouriteVC = segue.destination as! DetailRecipiesViewController
        favouriteVC.favouriteRecipies = sender as? Recipies
    }
}

extension FavouriteViewController {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
    
    func checkCurrentUser() {
        guard let currentUser = Auth.auth().currentUser else { return  }
        user = User(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("recipiesFromFavourite")
    }
}


    


