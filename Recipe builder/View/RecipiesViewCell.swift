//
//  RecipiesViewCell.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 08.10.2020.
//

import UIKit

class RecipiesViewCell: UITableViewCell {

    @IBOutlet var recipieImageView: ImageView!
    @IBOutlet var nameRecipieLabel: UILabel!
    @IBOutlet var describeRecipieLabel: UILabel!
    @IBOutlet var caloriesRecipeLabel: UILabel!
    @IBOutlet var totalWeightRecipeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.autoresizingMask = .flexibleHeight
        
    }
    
    
}
