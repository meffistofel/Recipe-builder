//
//  FavouriteViewController.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 19.10.2020.
//

import UIKit
import Firebase

class FavouriteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - IB Outlet
    @IBOutlet var tableView: UITableView!
    @IBOutlet var downloadFavouriteActivityIndicator: UIActivityIndicatorView!
    @IBOutlet var processDownloadLabel: UILabel!
    @IBOutlet var favListIsEmptyLabel: UILabel!
    
    // MARK: - Let & Var
    let searchController = UISearchController(searchResultsController: nil)
    var filteredRecipies = [Recipies]()
    
    var user: User!
    var ref: DatabaseReference!
    var recipiesFromFavourite = [Recipies]()
    
    // MARK: - Observers
    var isSearchBarEmpty: Bool {
        searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        searchController.isActive && !isSearchBarEmpty
    }
    
    var checkValueFilteredRecipies: Bool {
        recipiesFromFavourite.isEmpty
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        checkCurrentUser()
       
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        ref.observe(.value) { (snapshot) in
            var recipiesFavourite = [Recipies]()
            for item in snapshot.children {
                let recipe = Recipies(snapShot: item as! DataSnapshot)
                recipiesFavourite.append(recipe)
            }
            if self.isFiltering {
                self.filteredRecipies = recipiesFavourite
                self.tableView.reloadData()
            } else {
                self.recipiesFromFavourite = recipiesFavourite
                self.tableView.reloadData()
            }
        }
        checkValueFilteredRecipies ? favListEmpty() : startDownloadActivityIndicator()
    }
    
    // MARK: - Methods
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.isEditing = !tableView.isEditing
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltering ? filteredRecipies.count : recipiesFromFavourite.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favourite", for: indexPath) as! FavouriteTableViewCell
        
        let favouriteRecipe = isFiltering ? filteredRecipies[indexPath.row] : recipiesFromFavourite[indexPath.row]
        cell.configure(recipe: favouriteRecipe)
        
        
        stopDownloadActivityIndicator()
        placeSearchBarOnTableView()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recipe = recipiesFromFavourite[indexPath.row]
            recipe.ref?.removeValue()
        }
    }
    
    // MARK: - Navigation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let recipe = isFiltering ? filteredRecipies[indexPath.row] : recipiesFromFavourite[indexPath.row]
        performSegue(withIdentifier: "favouriteDescription", sender: recipe)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let favouriteVC = segue.destination as! DetailRecipiesViewController
        favouriteVC.favouriteRecipies = sender as? Recipies
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
}
// MARK: - Extension
extension FavouriteViewController: UISearchResultsUpdating {
    
    // MARK: - FireBase Auth
    func checkCurrentUser() {
        guard let currentUser = Auth.auth().currentUser else { return  }
        user = User(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("recipiesFromFavourite")
    }
    
    // MARK: - Fetch Favoutire Recipe
    private func startDownloadActivityIndicator() {
        tableView.isHidden = true
        downloadFavouriteActivityIndicator.isHidden = false
        downloadFavouriteActivityIndicator.color = .white
        downloadFavouriteActivityIndicator.startAnimating()
        downloadFavouriteActivityIndicator.hidesWhenStopped = true
    }
    
    private func stopDownloadActivityIndicator() {
        downloadFavouriteActivityIndicator.stopAnimating()
        processDownloadLabel.isHidden = true
        tableView.isHidden = false
    }
    
    private func favListEmpty() {
        tableView.isHidden = true
        downloadFavouriteActivityIndicator.isHidden = true
        processDownloadLabel.isHidden = true
        searchController.searchBar.isHidden = true
    }
    
    // MARK: - UISearch Conroller
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchtext(searchBar.text!)
    }
    
    func placeSearchBarOnTableView() {
        searchController.searchBar.isHidden = false
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Favoutire recipe"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func filterContentForSearchtext(_ searchText: String) {
        filteredRecipies = recipiesFromFavourite.filter({ (recipe: Recipies) -> Bool in
            recipe.recipe.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}





