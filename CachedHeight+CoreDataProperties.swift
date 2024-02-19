//
//  CachedHeight+CoreDataProperties.swift
//  CountriesListApp
//
//  Created by Григорий Душин on 19.02.2024.
//
//

import Foundation
import CoreData

@objc(CachedHeight)
public class CachedHeight: NSManagedObject {

    private struct Constants {
        static let fetchRequestEntityName = "CachedHeight"
    }
}

extension CachedHeight {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CachedHeight> {
        return NSFetchRequest<CachedHeight>(entityName: CachedHeight.Constants.fetchRequestEntityName)
    }

    @NSManaged public var height: NSObject?
    @NSManaged public var key: String?

}

extension CachedHeight : Identifiable {

}
