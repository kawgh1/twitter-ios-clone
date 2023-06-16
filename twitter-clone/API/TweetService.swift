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
        
        TWEETS_REF.childByAutoId().updateChildValues(values, withCompletionBlock: completion)
        
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
}
