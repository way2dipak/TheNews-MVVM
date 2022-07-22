//
//  LoginDataManager.swift
//  TheNews
//
//  Created by Dipak Singh on 15/07/22.
//  Copyright © 2022 developer.dipak. All rights reserved.
//

import Foundation

class LoginDataManager: LoginRepository {
    
    private let repo = LoginDataRepository()
    
    func saveGeneratedKey(apikey: String) {
        repo.saveGeneratedKey(apikey: apikey)
    }
    
    func retriveGeneratedKey() -> String? {
        return repo.retriveGeneratedKey()
    }
    
    func deleteApiKey() {
        repo.deleteApiKey()
    }
    
    
}
