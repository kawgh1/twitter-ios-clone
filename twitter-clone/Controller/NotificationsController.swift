//
//  NotificationsController.swift
//  twitter-clone
//
//  Created by J on 5/31/23.
//

import Foundation
import UIKit

class NotificationsController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    // MARK: - Helpers
    
    func configureUI(){
        view.backgroundColor = .white
        navigationItem.title = "Notifications"


    }
}
