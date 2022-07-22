//
//  CDHome+CoreDataProperties.swift
//  TheNews
//
//  Created by Dipak Singh on 30/06/22.
//  Copyright © 2022 developer.dipak. All rights reserved.
//
//

import Foundation
import CoreData


extension CDHome {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDHome> {
        return NSFetchRequest<CDHome>(entityName: "CDHome")
    }

    @NSManaged public var offset: Int64
    @NSManaged public var totalResults: Int64
    @NSManaged public var type: String
    @NSManaged public var json: String
}

extension CDHome {
    func getArticles() -> [ArticleModel]? {
        let jsonData = Data(json.utf8)
        let model = try? jsonData.decode() as [ArticleModel]
        return model
    }
}
