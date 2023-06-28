//
//  ProfileHeaderViewModel.swift
//  twitter-clone
//
//  Created by J on 6/24/23.
//

import UIKit

enum ProfileFilterOptions: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    var description: String {
        switch self {
        case .tweets: return "Tweets"
        case .replies: return "Tweets & Replies"
        case .likes: return "Likes"
        }
    }
}

struct ProfileHeaderViewModel {
    
    private let user: User
    let usernameText: String
    
    var followersString: NSAttributedString? {
        let followers = user.stats?.follwers
        return followers == 1 ? attributedText(withValue: 1, text: "follower") : attributedText(withValue: followers ?? 0, text: "followers")
    }
    
    var followingString: NSAttributedString? {
        return attributedText(withValue: user.stats?.following ?? 0, text: "following")
    }
    
    var actionButtonTitle: String {
        // if user is current user then set to "edit profile"
        if user.isCurrentUser {
            return "Edit Profile"
        }
        // else figure out following / not following
        
        if !user.isFollowed && !user.isCurrentUser {
            return "Follow"
        }
        
        if user.isFollowed {
            return "Following"
        }
        
        return "Loading"
    }

    
    init(user: User) {
        self.user = user
        self.usernameText = "@" + user.username
    }
    
    // used to create the "2 follwing" "4 followers" text effect
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)",
                                                        attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: " \(text)",
                               attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14),
                                            NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        return attributedTitle
    }
}
