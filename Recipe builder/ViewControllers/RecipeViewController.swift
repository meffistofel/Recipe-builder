//
//  RecipeViewController.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 14.10.2020.
//

import UIKit
import Kingfisher

class RecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - let, var & IBOutlet
    @IBOutlet var recipiesTableView: UITableView!
    @IBOutlet var downloadingRecipiesActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var loadingLabel: UILabel!
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private var foodType: FoodType!
    private var filteredRecipies: [Hit] = []
    
    // MARK: - Observes
    private var sortFoodType: [Hit] {
        foodType.hits.sorted { ($0.recipe.label < $1.recipe.label) }
    }
    
    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private var isFiltering: Bool {
        let searchBarIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty || searchBarIsFiltering)
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Scope Bar
        searchController.searchBar.scopeButtonTitles = ["30", "60", "120", "180"]
        searchController.searchBar.keyboardAppearance = UIKeyboardAppearance.dark
        searchController.searchBar.delegate = self
        startDownloadActivityIndicator()
        view.backgroundColor = .black
        
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredRecipies.count : foodType?.hits.count ?? 0
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
        let recipie = isFiltering ? filteredRecipies[indexPath.row].recipe : sortFoodType[indexPath.row].recipe
        performSegue(withIdentifier: "goDetailRecipe", sender: recipie)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goDetailRecipe" {
            let descriptionRecipiesVC = segue.destination as! DetailRecipiesViewController
            descriptionRecipiesVC.recipies = sender as? Recipe
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        95
    }
}

// MARK: - Extension
extension RecipeViewController: UISearchResultsUpdating, UISearchBarDelegate{
    
    // MARK: - Fetch Recipe
    func fetchRecipies(url: String) {
        AlomofireNetwork.fetchRecipies(url: url) { [weak self] (foodType) in
            self?.foodType = foodType
            DispatchQueue.main.async {
                self?.animateOpacity()
                self?.recipiesTableView.reloadData()
            }
        }
    }
    
    private func startDownloadActivityIndicator() {
        recipiesTableView.isHidden = true
        downloadingRecipiesActivityIndicator.color = .white
        downloadingRecipiesActivityIndicator.startAnimating()
        downloadingRecipiesActivityIndicator.hidesWhenStopped = true
    }
    
    private func stopDownloadActivityIndicator() {
        self.downloadingRecipiesActivityIndicator.stopAnimating()
        self.loadingLabel.isHidden = true
        self.recipiesTableView.isHidden = false
    }
    
    // MARK: - Extension UISearchBar
    func placeSearchBarOnTableView() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Are you hungry?"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchBar.text!, scope: Double(scope)!)
    }
    
    func filterContentForSearchText(_ searchText: String, scope: Double = 30) {
        var doesCategoryMacth = true
        filteredRecipies = sortFoodType.filter { (recipe: Hit) -> Bool in
            switch scope {
            case 30: doesCategoryMacth = (scope == 10) || (recipe.recipe.totalTime <= scope && recipe.recipe.totalTime > 0 )
            case 60: doesCategoryMacth = (scope == 10) || (recipe.recipe.totalTime <= scope && recipe.recipe.totalTime > 30)
            case 120: doesCategoryMacth = (scope == 10) || (recipe.recipe.totalTime <= scope && recipe.recipe.totalTime > 60)
            case 180: doesCategoryMacth = (scope == 10) || (recipe.recipe.totalTime <= scope && recipe.recipe.totalTime > 120)
            default: break
            }
            if isSearchBarEmpty {
                return doesCategoryMacth
            }
            return doesCategoryMacth && recipe.recipe.label.lowercased().contains(searchText.lowercased())
        }
        recipiesTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: Double(searchBar.scopeButtonTitles![selectedScope])!)
    }
    
    // MARK: - Extension Opasity Cell
    func animateOpacity() {
        searchController.searchBar.layer.opacity = 0
        recipiesTableView.layer.opacity = 0
        UIView.animate(withDuration: 0.7) {
            self.recipiesTableView.layer.opacity = 1
            self.searchController.searchBar.layer.opacity = 1
        }
    }
}
