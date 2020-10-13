//
//  ImageView.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 11.10.2020.
//

import UIKit

class ImageView: UIImageView {
    
    func imageFetch(from url: String) {
        
        guard let url = URL(string: url) else {
            image = #imageLiteral(resourceName: "icons8-банан-100")
            return
        }
        //
        // если изображения нет в кеше, то грузим его из интернета
        ImageManager.shared.getImage(from: url) { (data, response) in
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }
    }
}


