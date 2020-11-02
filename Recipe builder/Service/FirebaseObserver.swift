//
//  FirebaseObservers.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 31.10.2020.
//

import Foundation
import Firebase

class FirebaseService {
    
    static func firebaseObserverProfile(ref: DatabaseReference, completion: @escaping (_ profile: Profile) -> ()) {
        ref.observe(.value) { (snapshot) in
            for item in snapshot.children {
                let profile = Profile(snapshot: item as! DataSnapshot)
                completion(profile)
            }
        }
    }
    
    static func firebaseObserverFavouriteRecipies(ref: DatabaseReference, completion: @escaping (_ recipies: [Recipies]) -> ()) {
        ref.observe(.value) { (snapshot) in
            var recipiesFavourite = [Recipies]()
            for item in snapshot.children {
                let recipe = Recipies(snapShot: item as! DataSnapshot)
                recipiesFavourite.append(recipe)
            }
            completion(recipiesFavourite)
        }
    }
}
