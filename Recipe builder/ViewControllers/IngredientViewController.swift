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
    
    var checkTypeIngredient: Bool {
        ingredient == nil
    }
    
    var ingredient: Ingredient!
    var favouriteIngredient: Ingredient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkTypeIngredient ? fetchDetailFavouriteIngredient() : fetchDetailIngredient()
        
        transform(for: imageIngredientImageView,
                  nameAnimation: "transform.scale",
                  duration: 0.7,
                  fromValue: 0.97,
                  toValue: 1.15,
                  autoreverses: true,
                  repeatCount: Float.greatestFiniteMagnitude)
    }
    
    func fetchDetailIngredient() {
        nameIngredientLabel.text = ingredient.text
        
        DispatchQueue.global().async {
            let url = URL(string: self.ingredient.image ?? "https://i.imgur.com/NBVwpDH.png")
            DispatchQueue.main.async {
                self.imageIngredientImageView.kf.setImage(with: url)
                self.imageIngredientImageView.layer.cornerRadius = self.imageIngredientImageView.frame.width / 2
            }
        }
    }
    
    func fetchDetailFavouriteIngredient() {
        nameIngredientLabel.text = favouriteIngredient.text
        
        DispatchQueue.global().async {
            let url = URL(string: self.favouriteIngredient.image ?? "https://i.imgur.com/NBVwpDH.png")
            DispatchQueue.main.async {
                self.imageIngredientImageView.kf.setImage(with: url)
                self.imageIngredientImageView.layer.cornerRadius = self.imageIngredientImageView.frame.width / 2
            }
        }
    }
}

// MARK: - Extension: Animation
extension IngredientViewController {
    
    func transform(for view: UIView, nameAnimation: String, duration: CFTimeInterval, fromValue: Float, toValue: Float, autoreverses: Bool, repeatCount: Float) {
        
        let animation = CASpringAnimation(keyPath: nameAnimation)
        
        animation.duration = duration
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.autoreverses = autoreverses
        animation.repeatCount = repeatCount
        view.layer.add(animation, forKey: nil)
    }
}

