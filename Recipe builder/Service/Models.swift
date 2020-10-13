//
//  Models.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 08.10.2020.
//

import Foundation



struct FoodType: Decodable {
    
    var hits: [Hit]
    
    enum CodingKeys: String, CodingKey {
        
        case hits
    }
}


struct Hit: Decodable {
    let recipe: Recipe
    
    enum CodingKeys: String, CodingKey {
        
        case recipe
        
        
    }
}

struct Recipe: Decodable {
    let label: String
    let image: String
    let source: String
    let calories: Double
    let totalWeight: Double
    let ingredients: [Ingredient]
    
    
    enum CodingKeys: String, CodingKey {
        
        case label
        case image
        case source
        case calories
        case totalWeight
        case ingredients
        
    }
}

struct Ingredient: Decodable {
    let text: String
    
    enum CodingKeys: String, CodingKey {
        
        case text
    }
}




