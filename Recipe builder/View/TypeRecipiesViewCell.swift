//
//  TypeRecipiesViewCell.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 13.10.2020.
//

import UIKit

class TypeRecipiesViewCell: UICollectionViewCell {
    
    @IBOutlet var imageRecipieImageView: UIImageView!
    @IBOutlet var nameTypeRecipe: UILabel!
    
    func configure(with recipe: TypeRecipies) {
        nameTypeRecipe.text = recipe.nameImageRecipies
        imageRecipieImageView.layer.cornerRadius = 15
        imageRecipieImageView.image = UIImage(named: recipe.nameImageRecipies)
    }
}
