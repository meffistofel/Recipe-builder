//
//  Networking.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 08.10.2020.
//

import Foundation
import Alamofire

class AlomofireNetwork {
    
    static func fetchRecipies(url: String, completion: @escaping (_ foodType: FoodType) -> ()) {
        let urlParams = [
            "from": "0",
            "to": "100",
            "app_key": "bbc5be6bda7d5dda205f8b8b6eb2e387",
            "app_id": "a870bf45"
        ]
        
        guard let url = URL(string: url) else { return }
        
        AF.request(url, parameters: urlParams).validate().responseJSON { (response) in
            
            switch response.result {
            case .success(_):
                guard let data = response.data else { return }
                let foodType: FoodType = try! JSONDecoder().decode(FoodType.self, from: data)
                completion(foodType)
            case .failure(let error):
                print(error)
            }
        }
    }
}
