//
//  DetailRecipiesViewCell.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 15.10.2020.
//

import UIKit

class DetailRecipiesViewCell: UITableViewCell {
    
    @IBOutlet var ingridientLabel: UILabel!
    @IBOutlet var imageIngredientImageView: UIImageView!
    
    func configure(for recipe: Recipe, indexPath: IndexPath) {
        
        let recipie = recipe.ingredients[indexPath.row]
        contentView.backgroundColor = .black
        ingridientLabel.text = recipie.text
        ingridientLabel.textColor = .white
        
        DispatchQueue.global().async {
            let url = URL(string: recipie.image ?? "https://i.imgur.com/NBVwpDH.png")
            DispatchQueue.main.async {
                self.imageIngredientImageView.kf.setImage(with: url)
                self.imageIngredientImageView.layer.cornerRadius = self.imageIngredientImageView.frame.width / 2
            }
        }
    }
    
    func configureFavourite(for ingredient: Recipies, indexPath: IndexPath) {
         
        let ingreientName = ingredient.ingredientName[indexPath.row]
        let ingredientImage = ingredient.ingredientImage[indexPath.row]
        
        contentView.backgroundColor = .black
        ingridientLabel.text = ingreientName
        ingridientLabel.textColor = .white
        
        DispatchQueue.global().async {
            let url = URL(string: ingredientImage)
            DispatchQueue.main.async {
                self.imageIngredientImageView.kf.setImage(with: url)
                self.imageIngredientImageView.layer.cornerRadius = self.imageIngredientImageView.frame.width / 2
            }
        }
        
}
}
