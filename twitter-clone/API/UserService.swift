//
//  UserService.swift
//  twitter-clone
//
//  Created by J on 6/10/23.
//

import Firebase

typealias DatabaseCompletion = ((Error?, DatabaseReference) -> Void)

struct UserService {
    static let shared = UserService()
    
    func fetchUserById(uid: String, completion: @escaping(User) -> Void) {
        print("DEBUG: Fetch current User Info...")
        
        //        guard let uid = Auth.auth().currentUser?.uid else {return}
        //        print("DEBUG: Current Uid is \(uid)")
        
        USERS_REF.child(uid).observeSingleEvent(of: .value) { snapshot in
            
            guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
            //            print("DEBUG: Dictionary: \(dictionary)")
            guard dictionary["username"] is String else {return}
            let user = User(uid: uid, dictionary: dictionary)
            print("DEBUG: Fetched User by Id: \(user.username)")
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
    
    func followUser(uid: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        USER_FOLLOWING_REF.child(currentUid).updateChildValues([uid: 1]) { (err, ref) in
            USER_FOLLOWERS_REF.child(uid).updateChildValues([currentUid: 1], withCompletionBlock: completion)
        }
        
        //        print("DEBUG: Current uid \(currentUid) started following \(uid)")
        //        print("DEBUG: Uid \(uid) gained \(currentUid) as a follower")
        
    }
    
    // made use of Type Alias "DatabaseCompletion" to avoid having to type (Error?, DatabaseReference) each time
    func unfollowUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        USER_FOLLOWING_REF.child(currentUid).child(uid).removeValue { (err, ref) in
            USER_FOLLOWERS_REF.child(uid).child(currentUid).removeValue(completionBlock: completion)
        }
    }
    
    func checkIfUserIsFollowed(uid: String, completion: @escaping(Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        USER_FOLLOWING_REF.child(currentUid).child(uid).observeSingleEvent(of: .value) { snapshot in
            print("DEBUG: User is followed is \(snapshot.exists())")
            completion(snapshot.exists())
        }
    }
    
    func fetchUserStats(uid: String, completion: @escaping(UserRelationStats) -> Void) {
        USER_FOLLOWERS_REF.child(uid).observeSingleEvent(of: .value) { snapshot in
            let followers = snapshot.children.allObjects.count
//            print("DEBUG: Followers count is \(followers)")
            
            USER_FOLLOWING_REF.child(uid).observeSingleEvent(of: .value) { snapshot in
                let following = snapshot.children.allObjects.count
//                print("DEBUG: User is following \(following) other users")
                
                let stats = UserRelationStats(follwers: followers, following: following)
                completion(stats)

            }
        }
    }
}
