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
    
    private let recipiesURLChiken = "https://edamam-recipe-search.p.rapidapi.com/search?q=chicken"
    private let recipiesURLMeat = "https://edamam-recipe-search.p.rapidapi.com/search?q=meat"
    private let recipiesURLMilk = "https://edamam-recipe-search.p.rapidapi.com/search?q=milk"
    private let recipiesURLFish = "https://edamam-recipe-search.p.rapidapi.com/search?q=fish"
    
    
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recipies", for: indexPath) as! RecipiesViewCell
        
        let foodTypeOne = foodType.hits[indexPath.row]
        cell.configure(for: foodTypeOne)
        stopDownload()
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

extension RecipeViewController {
    
    func fetchRecipies() {
        AlomofireNetwork.fetchRecipies(url: recipiesURLChiken) { (foodType) in
            self.foodType = foodType
            DispatchQueue.main.async {
                self.recipiesTableView.reloadData()
            }
        }
    }
    
    func fetchRecipiesMeat() {
        AlomofireNetwork.fetchRecipies(url: recipiesURLMeat) { (foodType) in
            self.foodType = foodType
            DispatchQueue.main.async {
                self.recipiesTableView.reloadData()
            }
        }
    }
    
    func fetchRecipiesMilk() {
        AlomofireNetwork.fetchRecipies(url: recipiesURLMilk) { (foodType) in
            self.foodType = foodType
            DispatchQueue.main.async {
                self.recipiesTableView.reloadData()
            }
        }
    }
    
    func fetchRecipiesFish() {
        AlomofireNetwork.fetchRecipies(url: recipiesURLFish) { (foodType) in
            self.foodType = foodType
            DispatchQueue.main.async {
                self.recipiesTableView.reloadData()
            }
        }
    }
    
    func stopDownload() {
        self.downloadingRecipiesActivityIndicator.stopAnimating()
        self.loadingLabel.isHidden = true
        self.recipiesTableView.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    
    }
}
