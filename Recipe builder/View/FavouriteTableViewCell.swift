//
//  FavouriteTableViewCell.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 19.10.2020.
//

import UIKit

class FavouriteTableViewCell: UITableViewCell {

    @IBOutlet var nameRecipeLabel: UILabel!
    @IBOutlet var imageRecipeImageView: UIImageView!
    @IBOutlet var decribeRecipeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageRecipeImageView.layer.cornerRadius = imageRecipeImageView.frame.width / 2
    }

    func configure (recipe: Recipies) {
        
        nameRecipeLabel.text = recipe.recipe
        decribeRecipeLabel.text = recipe.describe
        DispatchQueue.global().async {
            guard let url = URL(string: recipe.image) else { return }
            DispatchQueue.main.async {
                self.imageRecipeImageView.kf.setImage(with: url)
            }
        }
    }
}
