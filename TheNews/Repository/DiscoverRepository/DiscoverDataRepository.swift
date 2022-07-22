//
//  DataRepository.swift
//  TheNews
//
//  Created by Dipak Singh on 27/06/22.
//  Copyright © 2022 developer.dipak. All rights reserved.
//

import Foundation
import CoreData

protocol DiscoverRepository {
    func checkIfCatregoryExist(for type: String) -> Bool
    func fetchDiscoverList(for type: String) -> ArticleResponse?
    func saveDiscoverList(offset: Int, type: String, list: ArticleResponse)
    func deleteDiscoverList(for type: String)
}

class DiscoverDataRepository: DiscoverRepository {
        
    func checkIfCatregoryExist(for type: String) -> Bool {
        let cdHomeFecth: NSFetchRequest = CDHome.fetchRequest()
        cdHomeFecth.predicate = NSPredicate(format: "type LIKE %@", type)
        do {
            let cdHomeResults = try PersistenceStorage.shared.context.fetch(cdHomeFecth)
            if cdHomeResults.count != 0 {
                return true
            } else {
                return false
            }
        } catch let error {
            print("Error😅: \(error.localizedDescription)")
            return false
        }
    }
    
    func fetchDiscoverList(for type: String) -> ArticleResponse? {
        let cdHomeFecth: NSFetchRequest = CDHome.fetchRequest()
        cdHomeFecth.predicate = NSPredicate(format: "type LIKE %@", type)
        do {
            let cdHomeResults = try PersistenceStorage.shared.context.fetch(cdHomeFecth)
            if cdHomeResults.count != 0 {
                let model = ArticleResponse(from: cdHomeResults.first)
                return model
            } else {
                return nil
            }
        } catch let error {
            print("Error😅: \(error.localizedDescription)")
            return nil
        }
    }
    
    func saveDiscoverList(offset: Int = 1, type: String, list: ArticleResponse) {
        if checkIfCatregoryExist(for: type) {
            //update
            let fetchRequest = CDHome.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "type LIKE %@", type)
            do {
                let cdHomeResults = try PersistenceStorage.shared.context.fetch(fetchRequest)
                if cdHomeResults.count != 0, let item = cdHomeResults.first {
                    item.offset = Int64(offset)
                    item.totalResults = Int64(item.totalResults)
                    var article = item.getArticles() ?? []
                    article += list.articles
                    item.json = article.toJSON()
                    PersistenceStorage.shared.saveContext()
                }
            } catch let error {
                print("Error😅: \(error.localizedDescription)")
            }
        } else {
            //save
            let cdHome = CDHome(context: PersistenceStorage.shared.context)
            cdHome.offset = Int64(offset)
            cdHome.totalResults = Int64(list.totalResults)
            cdHome.type = type
            cdHome.json = list.articles.toJSON()
            PersistenceStorage.shared.saveContext()
        }
    }
    
    func deleteDiscoverList(for type: String) {
        let fetchRequest = CDHome.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "type == %@", type)
        do {
            let results = try PersistenceStorage.shared.context.fetch(fetchRequest)
            for item in results {
                PersistenceStorage.shared.context.delete(item)
            }
        } catch let error {
            print("Error😅: \(error.localizedDescription)")
        }
    }
    
    func clearAllCDHomeData() {
        let fetchRequest = CDHome.fetchRequest()
        do {
            let results = try PersistenceStorage.shared.context.fetch(fetchRequest)
            for item in results {
                PersistenceStorage.shared.context.delete(item)
            }
        } catch let error {
            print("Error😅: \(error.localizedDescription)")
        }
    }
    
}
