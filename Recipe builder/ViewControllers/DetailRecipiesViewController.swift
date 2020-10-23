//
//  DetailRecipiesViewController.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 10.10.2020.
//

import UIKit
import Kingfisher
import Firebase

class DetailRecipiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - let, var & IBOutlet
    @IBOutlet var pictureRecipeImageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var seeFullRecipeLabel: UIButton!
    @IBOutlet var nameRecipeLabel: UILabel!
    @IBOutlet var сaloriesRecipeLabel: UILabel!
    @IBOutlet var weightRecipeLabel: UILabel!
    @IBOutlet var totalTimeLabel: UILabel!
    
    var recipies: Recipe!
    
    //firDatabase
    var user: User!
    var ref: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        pictureRecipeImageView.layer.cornerRadius = 20
        seeFullRecipeLabel.layer.cornerRadius = 10
        
        checkCurrentUser()
        fetchDetailRecipies()
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipies.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailRecipies", for: indexPath) as! DetailRecipiesViewCell
        cell.configure(for: recipies, indexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let ingredient = recipies.ingredients[indexPath.row]
        performSegue(withIdentifier: "goIngredient", sender: ingredient)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webKit" {
            let webKitVC = segue.destination as! WebViewController
            let url = recipies.url
            webKitVC.urlFullRecipe = url
        } else {
            let ingredientVC = segue.destination as! IngredientViewController
            ingredientVC.ingredient = sender as? Ingredient
        }
    }
    
    @IBAction func addTofavouriteRecipies(_ sender: UIBarButtonItem) {
        let recipe = Recipies(recipe: recipies, userId: user.uid)
        let recipeRef = ref.child(recipe.recipe.lowercased())
        recipeRef.setValue(recipe.convertToDictionary())
    }
    
}

// MARK: - Extension: Fetch Recipe
extension DetailRecipiesViewController {
    
    func fetchDetailRecipies() {
        navigationItem.title = recipies.label
        totalTimeLabel.text = String(format: "Time: %.0f", recipies.totalTime) + "min"
        сaloriesRecipeLabel.text = String(format: "Calories: %.0f", recipies.calories)
        weightRecipeLabel.text = String(format: "Weight: %.0f", recipies.totalWeight)
        
        DispatchQueue.global().async {
            let url = URL(string: self.recipies.image)
            DispatchQueue.main.async {
                self.pictureRecipeImageView.kf.setImage(with: url)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        52
    }
    
    func checkCurrentUser() {
        guard let currentUser = Auth.auth().currentUser else { return  }
        user = User(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("recipiesFromFavourite")
    }
}
