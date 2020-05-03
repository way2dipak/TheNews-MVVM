//
//  UserModel.swift
//  TheNews
//
//  Created by Nisha Poddar on 02/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import Foundation

struct UserModel {
    var userId: String?
    var idToken: String?
    var fullName: String?
    var givenName: String?
    var familyName: String?
    var email: String?
    var image: String?

    init(userId: String, idToken: String, fullName: String, givenName: String,familyName: String, email: String, image: String) {
        self.userId = userId
        self.idToken = idToken
        self.fullName = fullName
        self.givenName = givenName
        self.familyName = familyName
        self.email = email
        self.image = image
    }
}
