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
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var user: User!
    private var ref: DatabaseReference!
    
    var filteredRecipies = [Recipies]()
    var recipiesFromFavourite = [Recipies]()
    
    // MARK: - Observers
    private var isSearchBarEmpty: Bool {
        searchController.searchBar.text?.isEmpty ?? true
    }
    private var isFiltering: Bool {
        searchController.isActive && !isSearchBarEmpty
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNAvigationBar()
        checkCurrentUser()
        animateOpacity()
    }
    
    // MARK: - viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        FirebaseService.firebaseObserverFavouriteRecipies(ref: ref) {
            self.startDownloadActivityIndicator()
        } completion: { [weak self] (recipies) in
            self?.recipiesFromFavourite = recipies
            self?.tableView.reloadData()
            self?.checkValueFavouriteRecipies()
        }
        placeSearchBarOnTableView()
    }
    
    // MARK: - Methods
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.isEditing = !tableView.isEditing
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredRecipies.count : recipiesFromFavourite.count
    }
    
    func checkValueFavouriteRecipies() {
        recipiesFromFavourite.count >= 1 ? startDownloadActivityIndicator() : favListEmpty()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favourite", for: indexPath) as! FavouriteTableViewCell
        
        let favouriteRecipe = isFiltering ? filteredRecipies[indexPath.row] : recipiesFromFavourite[indexPath.row]
        cell.configure(recipe: favouriteRecipe)
        
        stopDownloadActivityIndicator()
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
        if segue.identifier == "favouriteDescription"{
            let favouriteVC = segue.destination as! DetailRecipiesViewController
            favouriteVC.favouriteRecipies = sender as? Recipies
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        90
    }
}

// MARK: - Extension
extension FavouriteViewController {
    
    // MARK: - FireBase Auth
    func checkCurrentUser() {
        guard let currentUser = Auth.auth().currentUser else { return  }
        user = User(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("recipiesFromFavourite")
    }
    
    // MARK: - Fetch Favoutire Recipe
    private func startDownloadActivityIndicator() {
        tableView.isHidden = true
        navigationItem.leftBarButtonItem?.isEnabled = false
        searchController.searchBar.isHidden = true
        favListIsEmptyLabel.isHidden = true
        processDownloadLabel.isHidden = false
        downloadFavouriteActivityIndicator.isHidden = false
        downloadFavouriteActivityIndicator.color = .white
        downloadFavouriteActivityIndicator.startAnimating()
        downloadFavouriteActivityIndicator.hidesWhenStopped = true
    }
    
    private func stopDownloadActivityIndicator() {
        downloadFavouriteActivityIndicator.stopAnimating()
        processDownloadLabel.isHidden = true
        tableView.isHidden = false
        searchController.searchBar.isHidden = false
        navigationItem.leftBarButtonItem?.isEnabled = true
    }
    
    private func favListEmpty() {
        tableView.isHidden = true
        downloadFavouriteActivityIndicator.isHidden = true
        processDownloadLabel.isHidden = true
        searchController.searchBar.isHidden = true
        favListIsEmptyLabel.isHidden = false
        self.navigationItem.leftBarButtonItem?.isEnabled = false
        
    }
    
    // MARK: - NagitaionBar
    func configureNAvigationBar() {
        self.navigationItem.leftBarButtonItem = editButtonItem
        self.navigationItem.leftBarButtonItem?.isEnabled = false
    }
    
    // MARK: - CLLayer
    func animateOpacity() {
        searchController.searchBar.layer.opacity = 0
        tableView.layer.opacity = 0
        UIView.animate(withDuration: 0.7) {
            self.tableView.layer.opacity = 1
            self.searchController.searchBar.layer.opacity = 1
        }
    }
}

extension FavouriteViewController: UISearchResultsUpdating, UISearchBarDelegate {
    
    // MARK: - UISearch Conroller
    func placeSearchBarOnTableView() {
        searchController.searchBar.isHidden = true
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Favoutire recipe"
        searchController.searchBar.keyboardAppearance = UIKeyboardAppearance.dark
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchtext(searchBar.text!)
    }
    
    func filterContentForSearchtext(_ searchText: String) {
        filteredRecipies = recipiesFromFavourite.filter({ (recipe: Recipies) -> Bool in
            recipe.recipe.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}





