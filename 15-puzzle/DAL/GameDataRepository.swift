//
//  GameDataRepository.swift
//  15-puzzle
//
//  Created by Gleb Engalychev on 11.01.2022.
//

import Foundation
import CoreData

class GameDataRepository {
    var container: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
    
    func getAllSavedGames() throws -> [SavedGame] {
        let saves = try context.fetch(SavedGame.fetchRequestSaves())
        return saves
    }
    
    func createSavedGame(save: SavedGame) throws {
        context.insert(save)
        try context.save()
    }
    
    func deleteSavedGame(save: SavedGame) throws {
        context.delete(save)
        try context.save()
    }
    
    func getAllLeaderStatistics() throws -> [LeaderboardStatistic] {
        let stats = try context.fetch(LeaderboardStatistic.fetchRequestLeaderbordStatistics())
        return stats
    }
    
    func createLeaderboardStatistic(stat: LeaderboardStatistic) throws {
        context.insert(stat)
        try context.save()
    }
    
    func deleteLeaderboardStatistic(stat: LeaderboardStatistic) throws {
        context.delete(stat)
        try context.save()
    }
}
