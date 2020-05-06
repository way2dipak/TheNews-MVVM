//
//  StoryBoardManager.swift
//  Prototype
//
//  Created by Embibe on 25/01/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import Foundation
import UIKit

class StoryBoardManager {
    
    static let shared = StoryBoardManager()
    private init() {}
    
    enum StoryBoardName: String {
        case Main = "Main"
        case DashBoard = "Dashboard"
        case Discover = "Discover"
        case Search = "Search"
        case HeadLines = "HeadLines"
        case More = "More"
        case Source = "Source"
        
    }
    
    /**
    use this manager to manage the storyboard for naviagtion as here two different storyboard is in used
    so insted of storyboard.instantiateViewController(withIdentifier: )
    example
    StoryboardManager.shared.getStoryboard(name:)
    */
    func getStoryboard(name: StoryBoardName) -> UIStoryboard {
        return UIStoryboard(name: name.rawValue, bundle: nil)
    }
    
}
