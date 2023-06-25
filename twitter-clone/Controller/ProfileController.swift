//
//  ProfileController.swift
//  twitter-clone
//
//  Created by J on 6/17/23.
//

import UIKit

private let reuseIdentifier = "TweetCell"
private let headerIdentifier = "ProfileHeader"

class ProfileController: UICollectionViewController {
    
    
    // MARK: - Properties
    private let user: User
    
    private var tweets = [Tweet]() {
        didSet { collectionView.reloadData()}
    }
    
    
    // MARK: - Lifecycle
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        fetchTweetsForUser()
        
        print("DEBUG: User is \(user)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black // make status bar icons white, doesnt work
        navigationController?.navigationBar.isHidden = true // made a custom nav bar

    }
    
    // MARK: - API
    
    func fetchTweetsForUser() {
        TweetService.shared.fetchTweetsForUser(user: user) { tweets in
            print("DEBUG: API call completed.. got user profile tweets..")
            self.tweets = tweets
        }
    }
    
    // MARK: - Helpers
    
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never // push top of ProfileHeader up to top edge of screen
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)

    }
}

// MARK: - UICollevtionView Profile Header

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        
        header.user = user
        header.delegate = self
        
        return header
    }
}

// MARK: - UICollectionView DataSource

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        return cell
    }
}

// MARK: - UICollectionView DelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout {
    // Profile Header
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}

// MARK: - ProfileHeader Delegate

extension ProfileController: ProfileHeaderDelegate {
    func handleDismissal() {
        print("DEBUG: Pressed dismiss..")
        navigationItem.hidesBackButton = true // dont show the back button before the user profile image loads on Feed Controller
        navigationController?.popViewController(animated: true)
    }
}
