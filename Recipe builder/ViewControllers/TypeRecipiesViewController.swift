//
//  TypeRecipiesViewController.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 13.10.2020.
//

import UIKit


class TypeRecipiesViewController: UICollectionViewController {
    
    var typeRecipies = TypeRecipies.getTypeRecipie()

    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let recipiesTVC = segue.destination as! RecipeViewController
        recipiesTVC.fetchRecipies()
    }
   
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        performSegue(withIdentifier: "goRecipies", sender: nil)
    }

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return typeRecipies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "blockRecipies", for: indexPath) as! TypeRecipiesViewCell
        
        let recipe = typeRecipies[indexPath.item]
        cell.nameTypeRecipe.text = recipe.nameImageRecipies
        cell.imageRecipieImageView.layer.cornerRadius = 15
        cell.imageRecipieImageView.image = UIImage(named: recipe.nameImageRecipies)

    
        return cell
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
