//
//  Constants.swift
//  twitter-clone
//
//  Created by J on 6/4/23.
//

import Foundation
import Firebase

let DB_REF = Database.database().reference()
let USERS_REF = DB_REF.child("users")
let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES_REF = STORAGE_REF.child("profiles_images")
