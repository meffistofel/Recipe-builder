//
//  RecipeViewController.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 14.10.2020.
//

import UIKit
import Kingfisher

class RecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet var recipiesTableView: UITableView!
    @IBOutlet var downloadingRecipiesActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var loadingLabel: UILabel!
    
    private var foodType: FoodType!
    private var sortFoodType: [Hit] {
        foodType.hits.sorted { ($0.recipe.label < $1.recipe.label) }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        downloadingRecipiesActivityIndicator.color = .white
        recipiesTableView.isHidden = true
        downloadingRecipiesActivityIndicator.startAnimating()
        downloadingRecipiesActivityIndicator.hidesWhenStopped = true
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foodType?.hits.count ?? 0
    }
    
    func fetchRecipies(url: String) {
        AlomofireNetwork.fetchRecipies(url: url) { (foodType) in
            self.foodType = foodType
            DispatchQueue.main.async {
                self.recipiesTableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipies", for: indexPath) as! RecipiesViewCell
        
        let foodTypeOne = sortFoodType[indexPath.row]
        cell.configure(for: foodTypeOne)
        stopDownload()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let recipie = sortFoodType[indexPath.row]
        performSegue(withIdentifier: "goDetailRecipe", sender: recipie)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goDetailRecipe" {
            let descriptionRecipiesVC = segue.destination as! DetailRecipiesViewController
            descriptionRecipiesVC.recipies = sender as? Hit
        }
    }
}

extension RecipeViewController {

    private func stopDownload() {
        self.downloadingRecipiesActivityIndicator.stopAnimating()
        self.loadingLabel.isHidden = true
        self.recipiesTableView.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
}
