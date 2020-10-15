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
        
        let headers: HTTPHeaders = [
            "x-rapidapi-host": "edamam-recipe-search.p.rapidapi.com",
            "x-rapidapi-key": "684889e899msh896a88624658631p1b5c2ajsnf58d8a018de7",
        ]
        
        let urlParams = [
            "from":"0",
            "to":"100"
        ]
        
        guard let url = URL(string: url) else { return }
        
        AF.request(url, parameters: urlParams, headers: headers).validate().responseJSON { (response) in
            
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
