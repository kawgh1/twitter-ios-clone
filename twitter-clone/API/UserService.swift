//
//  UserService.swift
//  twitter-clone
//
//  Created by J on 6/10/23.
//

import Firebase

struct UserService {
    static let shared = UserService()
    
    func fetchUserById(uid: String, completion: @escaping(User) -> Void) {
        print("DEBUG: Fetch current User Info...")
        
//        guard let uid = Auth.auth().currentUser?.uid else {return}
//        print("DEBUG: Current Uid is \(uid)")
        
        USERS_REF.child(uid).observeSingleEvent(of: .value) { snapshot in
            print("DEBUG: Snapshot: \(snapshot)")
            
            guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
//            print("DEBUG: Dictionary: \(dictionary)")
            
            guard dictionary["username"] is String else {return}
            
            let user = User(uid: uid, dictionary: dictionary)
            
            completion(user)
        }
    }
    
    func fetchUsers(completion: @escaping([User]) -> Void) {
        var users = [User]()
        
        USERS_REF.observe(.childAdded) { snapshot in
            let uid = snapshot.key
            
            guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
            let user = User(uid: uid, dictionary: dictionary)
            users.append(user)
            completion(users)
        }
    }
}
