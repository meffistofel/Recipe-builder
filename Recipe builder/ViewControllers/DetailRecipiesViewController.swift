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
    @IBOutlet var nameRecipeLabel: UILabel!
    @IBOutlet var seeFullRecipeLabel: UIButton!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var сaloriesRecipeLabel: UILabel!
    @IBOutlet var weightRecipeLabel: UILabel!
    
    var recipies: Hit!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        pictureRecipeImageView.layer.cornerRadius = 20
        seeFullRecipeLabel.layer.cornerRadius = 10
        
        fetchDetailRecipies()
        transform(for: pictureRecipeImageView,
                  nameAnimation: "transform.scale",
                  duration: 0.7,
                  fromValue: 0.97,
                  toValue: 1.00,
                  autoreverses: true,
                  repeatCount: Float.greatestFiniteMagnitude)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let url = recipies.recipe.url
            let webKitVC = segue.destination as! WebViewController
            webKitVC.urlFullRecipe = url
    }
}

    // MARK: - Extension: Animation
extension DetailRecipiesViewController {
    
    func transform(for view: UIView, nameAnimation: String, duration: CFTimeInterval, fromValue: Float, toValue: Float, autoreverses: Bool, repeatCount: Float) {
        
        let animation = CASpringAnimation(keyPath: nameAnimation)
        
        animation.duration = duration
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.autoreverses = autoreverses
        animation.repeatCount = repeatCount
        view.layer.add(animation, forKey: nil)
    }
}

    // MARK: - Extension: Fetch Recipe
extension DetailRecipiesViewController {
   
    func fetchDetailRecipies() {
        
        nameRecipeLabel.text = recipies.recipe.label
        DispatchQueue.global().async {
            let url = URL(string: self.recipies.recipe.image)
            DispatchQueue.main.async {
                self.pictureRecipeImageView.kf.setImage(with: url)
                self.сaloriesRecipeLabel.text = String(format: "Calories: %.0f", self.recipies.recipe.calories)
                self.weightRecipeLabel.text = String(format: "Weight: %.0f", self.recipies.recipe.totalWeight)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        52
    }
}
