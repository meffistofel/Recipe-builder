//
//  RecipiesViewCell.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 08.10.2020.
//

import UIKit

class RecipiesViewCell: UITableViewCell {
    
    @IBOutlet var recipieImageView: UIImageView!
    @IBOutlet var nameRecipieLabel: UILabel!
    @IBOutlet var describeRecipieLabel: UILabel!
    @IBOutlet var caloriesRecipeLabel: UILabel!
    @IBOutlet var totalWeightRecipeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(for recipe: Hit) {
        
        nameRecipieLabel.text = recipe.recipe.label
        describeRecipieLabel.text = recipe.recipe.source
        caloriesRecipeLabel.text = String(format: "calories: %.0f", recipe.recipe.calories)
        totalWeightRecipeLabel.text = String(format: "weight: %.0f", recipe.recipe.totalWeight)
        
        DispatchQueue.global().async {
            let url = URL(string: recipe.recipe.image)
            DispatchQueue.main.async {
                self.recipieImageView.kf.setImage(with: url)
                self.recipieImageView.layer.cornerRadius = self.recipieImageView.frame.width / 2
            }
        }
    }
}

