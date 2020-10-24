//
//  DetailFavouriteRecipeViewController.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 23.10.2020.
//

import UIKit
import Firebase
import Kingfisher

class DetailFavouriteRecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var pictureRecipeImageView: UIImageView!
    @IBOutlet var seeFullRecipeLabel: UIButton!
    @IBOutlet var сaloriesRecipeLabel: UILabel!
    @IBOutlet var weightRecipeLabel: UILabel!
    @IBOutlet var totalTimeLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var user: User!
    var ref: DatabaseReference!
    
    var favouriteRecipe: Recipies!

    override func viewDidLoad() {
        super.viewDidLoad()

        pictureRecipeImageView.layer.cornerRadius = 20
        seeFullRecipeLabel.layer.cornerRadius = 10
        
        fetchDetailRecipies()
        checkCurrentUser()
        
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favouriteRecipe.ingredientName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailRecipies", for: indexPath) as! DetailFavouriteTableViewCell
        let ingredientName = favouriteRecipe.ingredientName[indexPath.row]
        let ingredientFavouriteImage = favouriteRecipe.ingredientImage[indexPath.row]
        cell.ingridientLabel.text = ingredientName
        DispatchQueue.global().async {
            let url = URL(string: ingredientFavouriteImage)
            DispatchQueue.main.async {
                cell.imageIngredientImageView.kf.setImage(with: url)
                cell.imageIngredientImageView.layer.cornerRadius = cell.imageIngredientImageView.frame.width / 2
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let recipeName = favouriteRecipe.ingredientName[indexPath.row]
        let recipeImage = favouriteRecipe.ingredientImage[indexPath.row]
        let ingr = Ingredient(text: recipeName, image: recipeImage)
        performSegue(withIdentifier: "detailFavourite", sender: ingr)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailIFavouriteIngredientVC = segue.destination as! IngredientViewController
        detailIFavouriteIngredientVC.favouriteIngredient = sender as? Ingredient
    }
}

// MARK: - Extension: Fetch Recipe
extension DetailFavouriteRecipeViewController {
    
    func fetchDetailRecipies() {
        navigationItem.title = favouriteRecipe.recipe
        totalTimeLabel.text = String(format: "Time: %.0f", favouriteRecipe.totalTime) + "min"
        сaloriesRecipeLabel.text = String(format: "Calories: %.0f", favouriteRecipe.calories)
        weightRecipeLabel.text = String(format: "Weight: %.0f", favouriteRecipe.totalWeight)
        
        DispatchQueue.global().async {
            let url = URL(string: self.favouriteRecipe.image)
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


