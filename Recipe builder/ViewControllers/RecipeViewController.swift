//
//  RecipeViewController.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 14.10.2020.
//

import UIKit
import Kingfisher

class RecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    private var foodType: FoodType!
    private let recipiesURL = "https://edamam-recipe-search.p.rapidapi.com/search?q=chicken"
    @IBOutlet var recipiesTableView: UITableView!
    @IBOutlet var downloadingRecipiesActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var loadingLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        recipiesTableView.isHidden = true
        downloadingRecipiesActivityIndicator.startAnimating()
        downloadingRecipiesActivityIndicator.hidesWhenStopped = true
        
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodType?.hits.count ?? 0
    }
    
    func fetchRecipies() {
        AlomofireNetwork.fetchRecipies(url: recipiesURL) { (foodType) in
            self.foodType = foodType
            DispatchQueue.main.async {
                self.recipiesTableView.reloadData()
                self.downloadingRecipiesActivityIndicator.stopAnimating()
                self.loadingLabel.isHidden = true
                self.recipiesTableView.isHidden = false
                
            }
        }
    }
    
    private func configureCell(cell: RecipiesViewCell, indexPath: IndexPath) {
        
        
        let foodTypeOne = foodType.hits[indexPath.row]
        cell.nameRecipieLabel.text = foodTypeOne.recipe.label
        cell.describeRecipieLabel.text = foodTypeOne.recipe.source
        cell.caloriesRecipeLabel.text = String(format: "calories: %.0f", foodTypeOne.recipe.calories)
        cell.totalWeightRecipeLabel.text = String(format: "weight: %.0f", foodTypeOne.recipe.totalWeight)
        
        DispatchQueue.global().async {
            let url = URL(string: foodTypeOne.recipe.image)
            
            DispatchQueue.main.async {
                cell.recipieImageView.kf.setImage(with: url)
                cell.recipieImageView.layer.cornerRadius = cell.recipieImageView.frame.width / 2
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipies", for: indexPath) as! RecipiesViewCell
        
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let recipie = foodType.hits[indexPath.row]
        performSegue(withIdentifier: "goDetailRecipe", sender: recipie)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goDetailRecipe" {
            let descriptionRecipiesVC = segue.destination as! DetailRecipiesViewController
            descriptionRecipiesVC.recipies = sender as? Hit
        }
    }
}
