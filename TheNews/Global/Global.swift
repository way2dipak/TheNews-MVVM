//
//  UserObject.swift
//  TheNews
//
//  Created by Nisha Poddar on 02/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import Foundation
import UIKit

class Global {
    static let shared = Global()
    
    var userObj: UserModel?
    
     enum ScreenType {
        case discover
        case search
        case headlines
        case more
        case source
        case none
    }
    
    var currentScreenType: ScreenType = .none
}


