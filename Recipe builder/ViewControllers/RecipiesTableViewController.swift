//
//  RecipiesTableViewController.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 08.10.2020.
//

import UIKit
import Kingfisher

class RecipiesTableViewController: UITableViewController {
    
    private var foodType: FoodType!
    private let recipiesURL = "https://edamam-recipe-search.p.rapidapi.com/search?q=chicken"
    
    var indicator = UIActivityIndicatorView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator()
        indicator.startAnimating()
        indicator.hidesWhenStopped = true
        
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodType?.hits.count ?? 0
    }
    
    func fetchRecipies() {
        AlomofireNetwork.fetchRecipies(url: recipiesURL) { (foodType) in
            self.foodType = foodType
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.indicator.stopAnimating()
                self.tableView.separatorStyle = .singleLine
            }
        }
    }
    
    func activityIndicator() {
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        indicator.style = UIActivityIndicatorView.Style.gray
        indicator.center = self.view.center
        tableView.separatorStyle = .none
        self.view.addSubview(indicator)
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipies", for: indexPath) as! RecipiesViewCell
        
        configureCell(cell: cell, indexPath: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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


