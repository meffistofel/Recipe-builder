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
    let searchController = UISearchController(searchResultsController: nil)
    
    private var sortFoodType: [Hit] {
        foodType.hits.sorted { ($0.recipe.label < $1.recipe.label) }
    }
    
    private var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
        
    private var filteredRecipies: [Hit] = []
    
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
        return isFiltering ? filteredRecipies.count : foodType?.hits.count ?? 0
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
        
        let foodTypeOne = isFiltering ? filteredRecipies[indexPath.row] : sortFoodType[indexPath.row]
        cell.configure(for: foodTypeOne)
        
        stopDownloadActivityIndicator()
        placeSearchBarOnTableView()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let recipie = isFiltering ? filteredRecipies[indexPath.row] : sortFoodType[indexPath.row]
        performSegue(withIdentifier: "goDetailRecipe", sender: recipie)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goDetailRecipe" {
            let descriptionRecipiesVC = segue.destination as! DetailRecipiesViewController
            descriptionRecipiesVC.recipies = sender as? Hit
        }
    }
    
    func filterContentForSearchText(_ searchText: String) {
      
      filteredRecipies = sortFoodType.filter { (recipe: Hit) -> Bool in
        return recipe.recipe.label.lowercased().contains(searchText.lowercased())
      }
        recipiesTableView.reloadData()
    }
}

extension RecipeViewController {

    private func stopDownloadActivityIndicator() {
        self.downloadingRecipiesActivityIndicator.stopAnimating()
        self.loadingLabel.isHidden = true
        self.recipiesTableView.isHidden = false
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        110
    }
}

// MARK: - UISearchBar
extension RecipeViewController: UISearchResultsUpdating {
    
    func placeSearchBarOnTableView() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Recipies"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
    
    
}
