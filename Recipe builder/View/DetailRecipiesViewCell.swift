//
//  DetailRecipiesViewCell.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 15.10.2020.
//

import UIKit

class DetailRecipiesViewCell: UITableViewCell {
    
    @IBOutlet var ingridientLabel: UILabel!
    
    func configure(for recipe: Hit, indexPath: IndexPath) {
        
        let recipie = recipe.recipe.ingredients[indexPath.row]
        contentView.backgroundColor = .black
        ingridientLabel.text = recipie.text
        ingridientLabel.textColor = .white
    }
}
