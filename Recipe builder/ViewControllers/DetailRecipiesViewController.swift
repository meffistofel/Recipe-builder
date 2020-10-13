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
    
    @IBOutlet var pictureRecipeImageView: ImageView!
    @IBOutlet var nameRecipeLabel: UILabel!
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "detailRecipies")
        nameRecipeLabel.text = recipies.recipe.label
        DispatchQueue.main.async {
            let url = URL(string: self.recipies.recipe.image)
            self.pictureRecipeImageView.kf.setImage(with: url)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pictureRecipeImageView.layer.cornerRadius = 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipies.recipe.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "detailRecipies", for: indexPath)
        return cell
    }
}
