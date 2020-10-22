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
    let ref: DatabaseReference?
    
    init(recipe: Recipe, userId: String) {
        self.recipe = recipe.label
        self.userId = userId
        self.image = recipe.image
        self.describe = recipe.source
        self.ref = nil
    }
    
    init(snapShot: DataSnapshot) {
        let snapShotValue = snapShot.value as! [String: Any]
        recipe = snapShotValue["recipe"] as! String
        userId = snapShotValue["uerId"] as! String
        image = snapShotValue["image"] as! String
        describe = snapShotValue["describe"] as! String
        ref = snapShot.ref
    }
    
    func convertToDictionary() -> Any {
        return ["recipe": recipe, "uerId": userId, "image": image, "describe": describe ]
    }
}
