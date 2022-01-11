//
//  LeaderboardStatistic+CoreDataProperties.swift
//  15-puzzle
//
//  Created by Gleb Engalychev on 11.01.2022.
//
//

import Foundation
import CoreData


extension LeaderboardStatistic {

    @nonobjc public class func fetchRequestLeaderbordStatistics() -> NSFetchRequest<LeaderboardStatistic> {
        return NSFetchRequest<LeaderboardStatistic>(entityName: "LeaderboardStatistic")
    }

    @NSManaged public var playerName: String?
    @NSManaged public var timeSpent: Int32
    @NSManaged public var moveMade: Int32

}

extension LeaderboardStatistic : Identifiable {

}
