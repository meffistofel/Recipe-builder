//
//  IngredientViewController.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 18.10.2020.
//

import UIKit

class IngredientViewController: UIViewController {

    @IBOutlet var imageIngredientImageView: UIImageView!
    @IBOutlet var nameIngredientLabel: UILabel!
    
    var ingredient: Ingredient!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchInformation()
    }
    
    func fetchInformation() {
        nameIngredientLabel.text = ingredient.text
        
        DispatchQueue.global().async {
            let url = URL(string: self.ingredient.image ?? "https://i.imgur.com/NBVwpDH.png")
            DispatchQueue.main.async {
                self.imageIngredientImageView.kf.setImage(with: url)
                self.imageIngredientImageView.layer.cornerRadius = self.imageIngredientImageView.frame.width / 2
            }
        }
    }
}
