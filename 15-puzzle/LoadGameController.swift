//
//  LoadGameController.swift
//  15-puzzle
//
//  Created by Gleb Engalychev on 11.01.2022.
//

import UIKit
import CoreData

class LoadGameController: UIViewController {
    
    var container: NSPersistentContainer!
    var fetchController: NSFetchedResultsController<SavedGame>!
    var gameDataRepository: GameDataRepository!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard container != nil else {
            fatalError("This view need NSPersistentContainer!")
        }
        
        let savedGamesFetchRequest = SavedGame.fetchRequestSaves()
        savedGamesFetchRequest.sortDescriptors = [NSSortDescriptor(key: "saveDate", ascending: false)]
        
        fetchController = NSFetchedResultsController (
            fetchRequest: savedGamesFetchRequest,
            managedObjectContext: container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
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

extension LoadGameController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let saveGame = fetchController.object(at: indexPath)
        if let mainGameController = navigationController?.viewControllers.first as? MainGameController {
            mainGameController.brain.restoreGameBrainFromJSON(JSON: saveGame.gameJson!)
            mainGameController.updateUI()
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let savedGame = fetchController.object(at: indexPath)
            try? gameDataRepository.deleteSavedGame(save: savedGame)
        }
    }
}

extension LoadGameController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchController.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let savedGame = fetchController.object(at: indexPath)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH.mm.ss dd/MM/yy"
        let date = dateFormatter.string(from: savedGame.saveDate!)
        
        cell.selectionStyle = .none
        cell.textLabel?.text = "\(savedGame.saveName!), \(date)"
        return cell
    }
}

extension LoadGameController: NSFetchedResultsControllerDelegate {
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
