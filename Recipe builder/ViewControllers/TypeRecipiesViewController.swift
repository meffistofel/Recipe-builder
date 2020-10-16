//
//  TypeRecipiesViewController.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 13.10.2020.
//

import UIKit


class TypeRecipiesViewController: UICollectionViewController {
    
    var typeRecipies = TypeRecipies.getTypeRecipie()
    
    private let recipiesURLChiken = "https://edamam-recipe-search.p.rapidapi.com/search?q=chicken"
    private let recipiesURLMeat = "https://edamam-recipe-search.p.rapidapi.com/search?q=meat"
    private let recipiesURLMilk = "https://edamam-recipe-search.p.rapidapi.com/search?q=milk"
    private let recipiesURLFish = "https://edamam-recipe-search.p.rapidapi.com/search?q=fish"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return typeRecipies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "blockRecipies", for: indexPath) as! TypeRecipiesViewCell
        
        let recipe = typeRecipies[indexPath.item]
        cell.configure(with: recipe)
        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let recipiesTVC = segue.destination as! RecipeViewController
        switch segue.identifier {
        case "goRecipiesChiken": recipiesTVC.fetchRecipies(url: recipiesURLChiken)
        case "goRecipiesMeat": recipiesTVC.fetchRecipies(url: recipiesURLMeat)
        case "goRecipiesMilk": recipiesTVC.fetchRecipies(url: recipiesURLMilk)
        case "goRecipiesFish": recipiesTVC.fetchRecipies(url: recipiesURLFish)
        default: break
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = typeRecipies[indexPath.item]
        switch item.nameImageRecipies {
        case "Chicken": performSegue(withIdentifier: "goRecipiesChiken", sender: nil)
        case "Meat": performSegue(withIdentifier: "goRecipiesMeat", sender: nil)
        case "Milk": performSegue(withIdentifier: "goRecipiesMilk", sender: nil)
        case "Fish": performSegue(withIdentifier: "goRecipiesFish", sender: nil)
        default: break
        }
    }
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
