//
//  ViewController.swift
//  15-puzzle
//
//  Created by Gleb Engalychev on 08.12.2021.
//

import UIKit
import CoreData

class MainGameController: UIViewController {

    @IBOutlet weak var labelMoves: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    
    @IBOutlet var buttonCollectionGameBoardButtons: [UIButton]!
    
    var timer = Timer()
    var counter = 0
    
    var container: NSPersistentContainer!
    var gameDataRepository: GameDataRepository!
    
    var brain: GameBrain = GameBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gameDataRepository = GameDataRepository(container: container)
        let defaults = UserDefaults.standard
        let loadedBrain = defaults.string(forKey: "AutoSave")
        
        if (loadedBrain == nil) {
            startNewGame()
        } else {
            brain.restoreGameBrainFromJSON(JSON: loadedBrain!)
            startTimer()
            updateUI()
        }
        
    }

    @IBAction func buttonNewGameTouchUpInside(_ sender: UIButton) {
        startNewGame()
    }
    
    @IBAction func buttonGameButtonTouchUpInside(_ sender: UIButton) {
        let index = buttonCollectionGameBoardButtons.firstIndex(where: {$0 == sender})!
        let convertedIndex = String((index - index % 4) / 4) + String(index % 4)
        
        if (brain.validateMove(convertedIndex)) {
            updateUI()
        }
    }
    
    @IBAction func buttonUndoMoveTouchUpInside(_ sender: UIButton) {
        if (brain.isWin()) {
            return
        }
        
        brain.undoMove()
        updateUI()
    }
    
    @IBAction func buttonSaveGameTouchUpInside(_ sender: UIButton) {
        if (brain.isWin()) {
            return
        }
        
        let alert = UIAlertController(title: "Enter save name", message: "Please enter save name for a current game", preferredStyle: UIAlertController.Style.alert)
        
        alert.addTextField { t in t.placeholder = "Save name"}
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: UIAlertAction.Style.default) { _ in
            let savedGame = SavedGame(context: self.container.viewContext)
            savedGame.saveName = alert.textFields?[0].text ?? ""
            savedGame.gameJson = self.brain.getGameBrainJSON()
            savedGame.saveDate = Date()
            
            try? self.gameDataRepository.createSavedGame(save: savedGame)
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateUI() {
        let gameBoard = brain.getGameBoard()
        
        for x in 0..<gameBoard.count {
            for y in 0..<gameBoard[0].count {
                let gameButton = buttonCollectionGameBoardButtons[x * 4 + y]
                let gameElement = gameBoard[x][y]
                
                gameButton.setTitle(gameElement, for: .normal)
                
                if (gameElement == "X") {
                    gameButton.backgroundColor = .clear
                    gameButton.setTitleColor(.clear, for: .normal)
                } else {
                    gameButton.backgroundColor = .systemGray2
                    gameButton.setTitleColor(.label, for: .normal)
                }
            
            }
        }
        
        labelTime.text = "\(brain.getTime())"
        labelMoves.text = String(brain.getMoves())
        
        if (brain.isWin()) {
            timer.invalidate()
            
            let alert = UIAlertController(title: "Enter yout username", message: "Please enter your name for a finished game", preferredStyle: UIAlertController.Style.alert)
            
            alert.addTextField { t in t.placeholder = "Username"}
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "Save", style: UIAlertAction.Style.default) { _ in
                let leaderboardStatistic = LeaderboardStatistic(context: self.container.viewContext)
                leaderboardStatistic.playerName = alert.textFields?[0].text ?? ""
                leaderboardStatistic.timeSpent = Int32(self.brain.getTime())
                leaderboardStatistic.moveMade = Int32(self.brain.getMoves())
                
                try? self.gameDataRepository.createLeaderboardStatistic(stat: leaderboardStatistic)
            })
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    private func startNewGame() {
        brain.startNewGame()
        startTimer()
        updateUI()
    }
    
    @objc private func timerAction() {
        brain.incrementTime()
        labelTime.text = "\(brain.getTime())"
    }
    
    private func startTimer() {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? LoadGameController {
            destinationVC.container = self.container
        }
        
        if let destinationVC = segue.destination as? LeaderBoardController {
            destinationVC.container = self.container
        }
    }
}

