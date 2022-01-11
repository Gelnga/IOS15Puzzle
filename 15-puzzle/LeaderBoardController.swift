//
//  LeaderBoardController.swift
//  15-puzzle
//
//  Created by Gleb Engalychev on 11.01.2022.
//

import UIKit
import CoreData

class LeaderBoardController: UIViewController {
    
    var container: NSPersistentContainer!
    var fetchController: NSFetchedResultsController<LeaderboardStatistic>!
    var gameDataRepository: GameDataRepository!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard container != nil else {
            fatalError("This view need NSPersistentContainer!")
        }
        
        let leaderboardStatisticsFetchRequest = LeaderboardStatistic.fetchRequestLeaderbordStatistics()
        leaderboardStatisticsFetchRequest.sortDescriptors = [NSSortDescriptor(key: "moveMade", ascending: true)]
        
        fetchController = NSFetchedResultsController (
            fetchRequest: leaderboardStatisticsFetchRequest,
            managedObjectContext: container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "stat")
        tableView.delegate = self
        tableView.dataSource = self
        fetchController.delegate = self
        try? fetchController.performFetch()
        
        gameDataRepository = GameDataRepository(container: container)
    }
    
    @IBAction func buttonGoBackTouchUpInside(_ sender: UIButton) {
        _ = navigationController?.popViewController(animated: true)
    }
}

extension LeaderBoardController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let leaderboardStatistic = fetchController.object(at: indexPath)
            try? gameDataRepository.deleteLeaderboardStatistic(stat: leaderboardStatistic)
        }
    }
}

extension LeaderBoardController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "stat", for: indexPath)
        
        let leaderBoardStatistic = fetchController.object(at: indexPath)
        
        cell.selectionStyle = .none
        cell.textLabel?.text = "\(leaderBoardStatistic.playerName!). Time spent: \(String(leaderBoardStatistic.timeSpent)), Moves made: \(String(leaderBoardStatistic.moveMade))"
        return cell
    }
}

extension LeaderBoardController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .move:
            self.tableView.reloadData()
        case .update:
            self.tableView.reloadRows(at: [indexPath!], with: .automatic)
        @unknown default:
            fatalError("Unknown")
        }
    }
}

