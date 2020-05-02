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
        case Discover = "Discover"
        case Search = "Search"
        case HeadLines = "HeadLines"
        case More = "More"
        case DashBoard = "DashBoard"
        case Main = "Main"
    }
    
    /**
    use this manager to manage the storyboard for naviagtion as here two diffrent storyboard is in used
    so insted of storyboard.instantiateViewController(withIdentifier: )
    example
    StoryboardManager.shared.mainStoryboard.instantiateViewController(withIdentifier: )
    */
    let mainStoryboard = UIStoryboard(name: StoryBoardName.Main.rawValue, bundle: nil)
    
    /**
    use this manager to manage the storyboard for naviagtion as here two diffrent storyboard is in used
    so insted of storyboard.instantiateViewController(withIdentifier: )
    example
    StoryboardManager.shared.dashboardStoryboard.instantiateViewController(withIdentifier: )
    */
    let dashboardStoryboard = UIStoryboard(name: StoryBoardName.DashBoard.rawValue, bundle: nil)
    
    /**
     use this manager to manage the storyboard for naviagtion as here two diffrent storyboard is in used
     so insted of storyboard.instantiateViewController(withIdentifier: )
     example
     StoryboardManager.shared.discoverStoryboard.instantiateViewController(withIdentifier: )
     */
    let discoverStoryboard = UIStoryboard(name: StoryBoardName.Discover.rawValue, bundle: nil)
    /**
    use this manager to manage the storyboard for naviagtion as here two diffrent storyboard is in used
    so insted of storyboard.instantiateViewController(withIdentifier: )
    example
    StoryboardManager.shared.searchStoryboard.instantiateViewController(withIdentifier: )
    */
    let searchStoryboard = UIStoryboard(name: StoryBoardName.Search.rawValue, bundle: nil)
    /**
    use this manager to manage the storyboard for naviagtion as here two diffrent storyboard is in used
    so insted of storyboard.instantiateViewController(withIdentifier: )
    example
    StoryboardManager.shared.headLinesStoryboard.instantiateViewController(withIdentifier: )
    */
    let headLinesStoryboard = UIStoryboard(name: StoryBoardName.HeadLines.rawValue, bundle: nil)
    /**
    use this manager to manage the storyboard for naviagtion as here two diffrent storyboard is in used
    so insted of storyboard.instantiateViewController(withIdentifier: )
    example
    StoryboardManager.shared.moreStoryboard.instantiateViewController(withIdentifier: )
    */
    let moreStoryboard = UIStoryboard(name: StoryBoardName.More.rawValue, bundle: nil)
    
    
    
    
}
