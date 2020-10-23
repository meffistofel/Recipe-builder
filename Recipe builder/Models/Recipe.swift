//
//  Recipe.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 22.10.2020.
//

import Foundation
import Firebase

struct Recipies {
    
    let recipe: String
    let image: String
    let userId: String
    let describe: String
    let calories: Double
    let totalWeight: Double
    let totalTime: Double
    let url: String
    let ingredients: [Ingredient]
    let ref: DatabaseReference?
    
    init(recipe: Recipe, userId: String) {
        self.recipe = recipe.label
        self.userId = userId
        image = recipe.image
        describe = recipe.source
        ref = nil
        calories = recipe.calories
        totalWeight = recipe.totalWeight
        totalTime = recipe.totalTime
        url = recipe.url!
        ingredients = recipe.ingredients
    }
    
    init(snapShot: DataSnapshot) {
        let snapShotValue = snapShot.value as! [String: Any]
        recipe = snapShotValue["recipe"] as! String
        userId = snapShotValue["uerId"] as! String
        image = snapShotValue["image"] as! String
        describe = snapShotValue["describe"] as! String
        calories = snapShotValue["calories"] as! Double
        totalWeight = snapShotValue["totalWeight"] as! Double
        totalTime = snapShotValue["totalTime"] as! Double
        url = snapShotValue["url"] as! String
        ingredients = snapShotValue["ingredients"] as! [Ingredient]
        ref = snapShot.ref
    }
    
    func convertToDictionary() -> Any {
        return ["recipe": recipe, "uerId": userId, "image": image, "describe": describe, "calories": calories, "totalWeight": totalWeight, "totalTime": totalTime, "url": url, "ingredients": [ingredients[0].image, ingredients[1].text]]
        
//        "ingredients": ingredients
        
    }
}

//struct Ingredients {
//    let text: String
//    let image: String
//
//    init(ingredient: Ingredient, userId: String) {
//        text = ingredient.text
//        image = ingredient.image!
//    }
    
//    init(snapShot: DataSnapshot) {
//        let snapShotValue = snapShot.value as! [String: Any]
//        text = snapShotValue["text"] as! String
//        image = snapShotValue["image"] as! String
//    }
//    
//}
