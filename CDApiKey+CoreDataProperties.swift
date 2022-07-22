//
//  CDApiKey+CoreDataProperties.swift
//  TheNews
//
//  Created by Dipak Singh on 15/07/22.
//  Copyright © 2022 developer.dipak. All rights reserved.
//
//

import Foundation
import CoreData


extension CDApiKey {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDApiKey> {
        return NSFetchRequest<CDApiKey>(entityName: "CDApiKey")
    }

    @NSManaged public var apikey: String?

}
