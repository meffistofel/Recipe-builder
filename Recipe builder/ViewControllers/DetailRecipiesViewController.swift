//
//  DetailRecipiesViewController.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 10.10.2020.
//

import UIKit
import Kingfisher

class DetailRecipiesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var recipies: Hit!
    
    @IBOutlet var pictureRecipeImageView: UIImageView!
    @IBOutlet var nameRecipeLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "detailRecipies")
        fetchDetailRecipies()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pictureRecipeImageView.layer.cornerRadius = 30
    }
    
    func fetchDetailRecipies() {
        
        nameRecipeLabel.text = recipies.recipe.label
        DispatchQueue.global().async {
            let url = URL(string: self.recipies.recipe.image)
            DispatchQueue.main.async {
                self.pictureRecipeImageView.kf.setImage(with: url)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipies.recipe.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailRecipies", for: indexPath)
        
        let ingridient = recipies.recipe.ingredients[indexPath.row]
        cell.textLabel?.text = ingridient.text
        return cell
    }
}
