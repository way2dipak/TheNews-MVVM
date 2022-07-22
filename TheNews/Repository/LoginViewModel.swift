//
//  LoginViewModel.swift
//  TheNews
//
//  Created by Dipak Singh on 28/06/22.
//  Copyright © 2022 developer.dipak. All rights reserved.
//

import Foundation
import UIKit

class LoginViewModel {
    
    private let dataManager = LoginDataManager()
    
    func performSign(vc: UIViewController,
                     callback: @escaping(() -> ())) {
        presentAccountVC(vcObj: vc,
                         completion: callback)
    }
    
    func saveApiKey(apiKey: String) {
        dataManager.saveGeneratedKey(apikey: apiKey)
        Global.shared.apikey = apiKey
    }
    
    func restoreApiKey() -> String? {
        return dataManager.retriveGeneratedKey()
    }
    
    func clearApi() {
        dataManager.deleteApiKey()
    }
    
    func restorePreviousSignin(completion: @escaping((String) -> ())) {
        completion(restoreApiKey() ?? "")
    }
   
    func presentAccountVC(vcObj: UIViewController, completion: @escaping(() -> ())) {
        let vc = StoryBoardManager.shared.getStoryboard(name: .Account).instantiateViewController(withIdentifier: AccountVC.identifier) as! AccountVC
        vc.dismissHandler = completion
        vc.type = .login
        vcObj.present(vc, animated: true)
    }
}
