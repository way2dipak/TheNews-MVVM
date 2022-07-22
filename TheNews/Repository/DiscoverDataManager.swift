//
//  DiscoverDataManager.swift
//  TheNews
//
//  Created by Dipak Singh on 28/06/22.
//  Copyright © 2022 developer.dipak. All rights reserved.
//

import Foundation

class DiscoverDataManager: DiscoverRepository {
    
    private let network = NetworkManagerClient()
    private let repo = DiscoverDataRepository()
    
    func checkIfCatregoryExist(for type: String) -> Bool {
        repo.checkIfCatregoryExist(for: type)
    }
    
    func fetchDiscoverList(for type: String) -> ArticleResponse? {
        return repo.fetchDiscoverList(for: type)
    }
    
    func saveDiscoverList(offset: Int,
                          type: String,
                          list: ArticleResponse) {
        repo.saveDiscoverList(offset: offset,
                              type: type,
                              list: list)
    }
    
    func fetchDiscoverList(with type: String,
                           isPaginationRequired: Bool = false,
                           clearList: Bool = false,
                           for pageNo: Int,
                           completion: @escaping((ArticleResponse?) -> Void)) {
        if clearList {
           // deleteDiscoverList(for: type)
        }
//        if !isPaginationRequired {
//            if let article = fetchDiscoverList(for: type) {
//                completion(article)
//                return
//            }
//        }
        if !Reachability.isConnectedToNetwork() {
            if let article = fetchDiscoverList(for: type) {
                completion(article)
                return
            }
        }
        let request = URLRepository.discover(type, pageNo).dataRequest
        network.httpRequestWith(request) { [weak self] (response: ArticleResponse) in
            guard let self = self else { return }
            //self.repo.clearAllCDHomeData()
            self.saveDiscoverList(offset: pageNo,
                                  type: type,
                                  list: response)
            completion(response)
        } failure: { error in
            print("Error: \(error ?? "")")
        }
    }
    
    func deleteDiscoverList(for type: String) {
        repo.deleteDiscoverList(for: type)
    }
    
}
