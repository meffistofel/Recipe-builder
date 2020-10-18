//
//  DetailRecipiesViewController.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 10.10.2020.
//

import UIKit
import Kingfisher

class DetailRecipiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - let, var & IBOutlet
    @IBOutlet var pictureRecipeImageView: UIImageView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var seeFullRecipeLabel: UIButton!
    @IBOutlet var nameRecipeLabel: UILabel!
    @IBOutlet var сaloriesRecipeLabel: UILabel!
    @IBOutlet var weightRecipeLabel: UILabel!
    @IBOutlet var totalTimeLabel: UILabel!
    
    var recipies: Hit!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pictureRecipeImageView.layer.cornerRadius = 20
        seeFullRecipeLabel.layer.cornerRadius = 10
        
        fetchDetailRecipies()
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipies.recipe.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailRecipies", for: indexPath) as! DetailRecipiesViewCell
        cell.configure(for: recipies, indexPath: indexPath)
        
        return cell
    }
    
    @IBAction func seeFullRecipies(_ sender: UIButton) {
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let ingredient = recipies.recipe.ingredients[indexPath.row]
        performSegue(withIdentifier: "goIngredient", sender: ingredient)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webKit" {
            let webKitVC = segue.destination as! WebViewController
            let url = recipies.recipe.url
            webKitVC.urlFullRecipe = url
        } else {
            let ingredientVC = segue.destination as! IngredientViewController
            ingredientVC.ingredient = sender as? Ingredient
        }
    }
}

// MARK: - Extension: Fetch Recipe
extension DetailRecipiesViewController {
    
    func fetchDetailRecipies() {
        navigationItem.title = recipies.recipe.label
//        nameRecipeLabel.text = recipies.recipe.label
        totalTimeLabel.text = String(format: "Time: %.0f", recipies.recipe.totalTime) + "min"
        сaloriesRecipeLabel.text = String(format: "Calories: %.0f", recipies.recipe.calories)
        weightRecipeLabel.text = String(format: "Weight: %.0f", recipies.recipe.totalWeight)
        
        DispatchQueue.global().async {
            let url = URL(string: self.recipies.recipe.image)
            DispatchQueue.main.async {
                self.pictureRecipeImageView.kf.setImage(with: url)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        52
    }
}
