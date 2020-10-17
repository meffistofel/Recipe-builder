//
//  Models.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 08.10.2020.
//

import Foundation

struct FoodType: Decodable {
    
    let hits: [Hit]
}

struct Hit: Decodable {
    let recipe: Recipe
}

struct Recipe: Decodable {
    let label: String
    let image: String
    let source: String
    let calories: Double
    let totalWeight: Double
    let ingredients: [Ingredient]
    let url: String?

}

struct Ingredient: Decodable {
    let text: String
    let image: String?
}

//    enum CodingKeys: String, CodingKey {
//
//        case text
//        case image
//    }


