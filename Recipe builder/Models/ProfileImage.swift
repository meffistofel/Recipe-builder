//
//  profileImage.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 30.10.2020.
//

import Foundation
import Firebase

struct ImageProfile {
    
    let image: String
    let ref: DatabaseReference?
    
    init(image: String) {
        self.image = image
        ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapShotValue = snapshot.value as! String
        image = snapShotValue
        ref = snapshot.ref
    }
}
