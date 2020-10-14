//
//  TypeRecipiesModel.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 13.10.2020.
//

import Foundation

struct TypeRecipies {
    
    let nameImageRecipies: String
}

extension TypeRecipies {
    static func getTypeRecipie() -> [TypeRecipies] {
        return [
            TypeRecipies(nameImageRecipies: "Meat"),
            TypeRecipies(nameImageRecipies: "Chicken"),
            TypeRecipies(nameImageRecipies: "Milk"),
            TypeRecipies(nameImageRecipies: "Fish")
        ]
    }
}
