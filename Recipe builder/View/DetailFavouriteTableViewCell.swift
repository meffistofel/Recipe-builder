//
//  DetailFavouriteTableViewCell.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 23.10.2020.
//

import UIKit

class DetailFavouriteTableViewCell: UITableViewCell {

    @IBOutlet var imageIngredientImageView: UIImageView!
    @IBOutlet var ingridientLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = .black
        ingridientLabel.textColor = .white
    }

}
