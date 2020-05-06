//
//  DashBoardTabController.swift
//  TheNews
//
//  Created by DS on 02/05/20.
//  Copyright © 2020 developer.dipak. All rights reserved.
//

import UIKit

class DashBoardTabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        Global.shared.currentScreenType = .discover
    }
    
}

extension DashBoardTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        switch tabBarController.selectedIndex {
        case 0:
            Global.shared.currentScreenType = .discover
        case 1:
            Global.shared.currentScreenType = .search
        case 2:
            Global.shared.currentScreenType = .headlines
        case 3:
            Global.shared.currentScreenType = .more
        default:
            Global.shared.currentScreenType = .none
        }
    }
}
