//
//  DetailRecipiesViewController.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 10.10.2020.
//

import UIKit
import Kingfisher
import Firebase

class DetailRecipiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - let, var & IBOutlet
    @IBOutlet var pictureRecipeImageView: UIImageView!
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var seeFullRecipeLabel: UIButton!
    
    @IBOutlet var сaloriesRecipeLabel: UILabel!
    @IBOutlet var weightRecipeLabel: UILabel!
    @IBOutlet var totalTimeLabel: UILabel!
    
    @IBOutlet var addFavouriteRecipeBarButton: UIBarButtonItem!
    
    // MARK: - Let & Var
    var recipies: Recipe!
    var favouriteRecipies: Recipies!
    
    var user: User!
    var ref: DatabaseReference!
    
    // MARK: - Observers
    var checkRecipeType: Bool {
        recipies == nil
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
         
        
        checkCurrentUser()
        checkRecipeType ? fetchDetailFavouriteRecipies() : fetchDetailRecipies()
        configLayer()
        makeColorHeartFavourite()
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        checkRecipeType ? favouriteRecipies.ingredientName.count : recipies.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailRecipies", for: indexPath) as! DetailRecipiesViewCell
        
        checkRecipeType ? cell.configureFavourite(for: favouriteRecipies, indexPath: indexPath) : cell.configure(for: recipies, indexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if checkRecipeType {
            let ingredientName = favouriteRecipies.ingredientName[indexPath.row]
            let ingredientImage = favouriteRecipies.ingredientImage[indexPath.row]
            let ingredient = Ingredient(text: ingredientName, image: ingredientImage)
            performSegue(withIdentifier: "goIngredient", sender: ingredient)
        } else {
        let ingredient = recipies.ingredients[indexPath.row]
        performSegue(withIdentifier: "goIngredient", sender: ingredient)
        }
    }
    
    // MARK: - NAvigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "webKit" {
            let webKitVC = segue.destination as! WebViewController
            let url = checkRecipeType ? favouriteRecipies.url : recipies.url
            webKitVC.urlFullRecipe = url
        } else {
            let ingredientVC = segue.destination as! IngredientViewController
            ingredientVC.ingredient = sender as? Ingredient
        }
    }
    
    // MARK: - IB Actions
    @IBAction func addTofavouriteRecipies(_ sender: UIBarButtonItem) {
        if checkRecipeType {
            addFavouriteRecipeBarButton.image = UIImage(systemName: "heart")
            addFavouriteRecipeBarButton.tintColor = .white
            favouriteRecipies.ref?.removeValue()
        } else {
            addFavouriteRecipeBarButton.image = UIImage(systemName: "heart.fill")
            addFavouriteRecipeBarButton.tintColor = .red
            let recipe = Recipies(recipe: recipies, userId: user.uid)
            let recipeRef = ref.child(recipe.recipe.lowercased())
            recipeRef.setValue(recipe.convertToDictionary())
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        52
    }
}

// MARK: - Extension
extension DetailRecipiesViewController {
    
    // MARK: - Fetch Recipe
    func fetchDetailRecipies() {
        navigationItem.title = recipies.label
        totalTimeLabel.text = String(format: "Time: %.0f", recipies.totalTime) + "min"
        сaloriesRecipeLabel.text = String(format: "Calories: %.0f", recipies.calories)
        weightRecipeLabel.text = String(format: "Weight: %.0f", recipies.totalWeight)
        
        DispatchQueue.global().async {
            let url = URL(string: self.recipies.image)
            DispatchQueue.main.async {
                self.pictureRecipeImageView.kf.setImage(with: url)
            }
        }
    }
    
    func fetchDetailFavouriteRecipies() {
        navigationItem.title = favouriteRecipies.recipe
        totalTimeLabel.text = String(format: "Time: %.0f", favouriteRecipies.totalTime) + "min"
        сaloriesRecipeLabel.text = String(format: "Calories: %.0f", favouriteRecipies.calories)
        weightRecipeLabel.text = String(format: "Weight: %.0f", favouriteRecipies.totalWeight)
        
        DispatchQueue.global().async {
            let url = URL(string: self.favouriteRecipies.image)
            DispatchQueue.main.async {
                self.pictureRecipeImageView.kf.setImage(with: url)
            }
        }
    }
    
    // MARK: - FavouriteRecipeImage
    func makeColorHeartFavourite() {
        if checkRecipeType {
            addFavouriteRecipeBarButton.image = UIImage(systemName: "heart.fill")
            addFavouriteRecipeBarButton.tintColor = .red
        } else {
            addFavouriteRecipeBarButton.image = UIImage(systemName: "heart")
            addFavouriteRecipeBarButton.tintColor = .white
        }
    }
    
    // MARK: - FireBase Auth
    func checkCurrentUser() {
        guard let currentUser = Auth.auth().currentUser else { return  }
        user = User(user: currentUser)
        ref = Database.database().reference(withPath: "users").child(String(user.uid)).child("recipiesFromFavourite")
    }
    
    // MARK: - CLLayer
    func configLayer() {
        pictureRecipeImageView.layer.cornerRadius = 20
        seeFullRecipeLabel.layer.cornerRadius = 10
    }
    
}
