//
//  ImageNetwork.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 11.10.2020.
//

import Foundation
import Alamofire
import Kingfisher

class ImageManager {
    
    static let shared = ImageManager()
    
    private init() {}
    
    let headers: HTTPHeaders = [
        "x-rapidapi-host": "edamam-recipe-search.p.rapidapi.com",
        "x-rapidapi-key": "684889e899msh896a88624658631p1b5c2ajsnf58d8a018de7"
    ]
    
    let urlParams = [
        "q":"meat, fish, chicken, milk",
        "from":"0",
        "to":"100"
    ]
    
    func getImage(from url: URL, completion: @escaping(Data, URLResponse) -> ()) {
        AF.request(url, parameters: urlParams, headers: headers).validate().responseData { (response) in
            
            switch response.result {
            case .success(_):
                guard let data = response.data else { return }
                guard let response = response.response else { return }
                completion(data, response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
}
