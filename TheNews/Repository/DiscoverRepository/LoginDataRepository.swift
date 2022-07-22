//
//  LoginDataRepository.swift
//  TheNews
//
//  Created by Dipak Singh on 15/07/22.
//  Copyright © 2022 developer.dipak. All rights reserved.
//

import Foundation

protocol LoginRepository {
    func saveGeneratedKey(apikey: String)
    func retriveGeneratedKey() -> String?
    func deleteApiKey()
}

class LoginDataRepository: LoginRepository {
    func saveGeneratedKey(apikey: String) {
        let cdApiKey = CDApiKey(context: PersistenceStorage.shared.context)
        cdApiKey.apikey = apikey
        PersistenceStorage.shared.saveContext()
    }
    
    func retriveGeneratedKey() -> String? {
        let fetchRequest = CDApiKey.fetchRequest()
        do {
            let results = try PersistenceStorage.shared.context.fetch(fetchRequest)
            if results.count != 0 {
                return results.first?.apikey ?? ""
            }
            return nil
        } catch let error {
            print("Error😅: \(error.localizedDescription)")
            return nil
        }
    }
    
    func deleteApiKey() {
        let fetchRequest = CDApiKey.fetchRequest()
        do {
            let results = try PersistenceStorage.shared.context.fetch(fetchRequest)
            for item in results {
                PersistenceStorage.shared.context.delete(item)
                PersistenceStorage.shared.saveContext()
            }
        } catch let error {
            print("Error😅: \(error.localizedDescription)")
        }
    }
}
