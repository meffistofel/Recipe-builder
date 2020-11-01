//
//  Profile.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 27.10.2020.
//

import Foundation
import Firebase

struct Profile {
    
    let userId: String
    let name: String
    let surName: String
    let ref: DatabaseReference?
    
    init(name: String, surName: String, userId: String) {
        self.userId = userId
        self.name = name
        self.surName = surName
        ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapShotValue = snapshot.value as! [String: Any]
        userId = snapShotValue["uerId"] as! String
        name = snapShotValue["name"] as! String
        surName = snapShotValue["surName"] as! String
        ref = snapshot.ref
    }
    
    func convertToDictionary() -> Any {
        return ["name": name, "surName": surName, "uerId": userId]
    }
}
