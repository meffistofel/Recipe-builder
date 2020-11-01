//
//  FirebaseObservers.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 31.10.2020.
//

import Foundation
import Firebase
import Kingfisher

class FirebaseService {
    
    static func firebaseObserverProfile(ref: DatabaseReference, completion: @escaping (_ profile: Profile) -> ()) {
        ref.observe(.value) { (snapshot) in
            for item in snapshot.children {
                let profile = Profile(snapshot: item as! DataSnapshot)
                completion(profile)
            }
        }
    }
}
