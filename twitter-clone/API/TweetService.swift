//
//  TweetService.swift
//  twitter-clone
//
//  Created by J on 6/10/23.
//

import Firebase

struct TweetService {
    static let shared = TweetService()
    
    func uploadTweet(caption: String, completion: @escaping(Error?, DatabaseReference) -> Void) {
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let values = ["uid": uid,
                      "timestamp": Int(NSDate().timeIntervalSince1970),
                      "likes": 0,
                      "retweets": 0,
                      "caption": caption
        ] as [String: Any]
        
        let ref = TWEETS_REF.childByAutoId()
        
        // use tweetId from autoId in TWEETS_REF to insert the users tweet in their own USER_TWEETS_REF collection
        ref.updateChildValues(values) { (err, ref) in
            guard let tweetId = ref.key else {return}
            USER_TWEETS_REF.child(uid).updateChildValues([tweetId: 1], withCompletionBlock: completion)
        }
        
    }
    
    func fetchTweets(completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        // .childAdded is a firebase listener that grabs the last added item to the collection and returns it
        TWEETS_REF.observe(.childAdded) { snapshot  in
            guard let dictionary = snapshot.value as? [String: Any] else {return}
            guard let uid = dictionary["uid"] as? String else {return}
            let tweetId = snapshot.key
            
            UserService.shared.fetchUserById(uid: uid) { user in
                let tweet = Tweet(user: user, tweetId: tweetId, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
            
            
        }
    }
    
    func fetchTweetsForUser(user: User, completion: @escaping([Tweet]) -> Void) {
        var tweets = [Tweet]()
        
        USER_TWEETS_REF.child(user.uid).observe(.childAdded) { snapshot in
            let tweetId = snapshot.key
            
            TWEETS_REF.child(tweetId).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String: Any] else {return}
                guard let uid = dictionary["uid"] as? String else {return}
                
                UserService.shared.fetchUserById(uid: uid) { user in
                    let tweet = Tweet(user: user, tweetId: tweetId, dictionary: dictionary)
                    tweets.append(tweet)
                    completion(tweets)
                }
            }
            
        }
        
    }
}
