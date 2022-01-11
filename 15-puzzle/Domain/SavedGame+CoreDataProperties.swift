//
//  SavedGame+CoreDataProperties.swift
//  15-puzzle
//
//  Created by Gleb Engalychev on 11.01.2022.
//
//

import Foundation
import CoreData


extension SavedGame {

    @nonobjc public class func fetchRequestSaves() -> NSFetchRequest<SavedGame> {
        return NSFetchRequest<SavedGame>(entityName: "SavedGame")
    }

    @NSManaged public var saveName: String?
    @NSManaged public var saveDate: Date?
    @NSManaged public var gameJson: String?

}

extension SavedGame : Identifiable {

}
