//
//  UserViewModel.swift
//  TheNews
//
//  Created by Nisha Poddar on 02/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import Foundation

struct UserViewModel {
    var user: UserModel?
    
    init(_ user: UserModel) {
        self.user = user
    }
}
