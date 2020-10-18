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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(for recipe: Hit) {
        
        nameRecipieLabel.text = recipe.recipe.label
        describeRecipieLabel.text = recipe.recipe.source
        
        DispatchQueue.global().async {
            let url = URL(string: recipe.recipe.image)
            DispatchQueue.main.async {
                self.recipieImageView.kf.setImage(with: url)
                self.recipieImageView.layer.cornerRadius = self.recipieImageView.frame.width / 2
            }
        }
    }
}



