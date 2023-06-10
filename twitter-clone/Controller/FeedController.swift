//
//  FeedController.swift
//  twitter-clone
//
//  Created by J on 5/31/23.
//

import UIKit
import SDWebImage

class FeedController: UIViewController {
    
    // MARK: - Properties
    
    var user: User? {
        didSet {
            print("DEBUG: Did set user in Feed Controller..")
            configureLeftBarButton()
        }
    }
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    
    // MARK: - Helpers
    
    func configureUI(){
        view.backgroundColor = .white
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44) // center the bird
        navigationItem.titleView = imageView
    }
    
    func configureLeftBarButton() {
        
        // profile image in nav bar has to be retrieved from DB async before Controller can load
        // other wise it will load without the profile image immediately on startup
        // so we call it in the User didSet function
        
        guard let user = user else {return}
        
        
        let profileImageView = UIImageView()
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32/2
        
        profileImageView.layer.masksToBounds = true // make circle
        
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
}
