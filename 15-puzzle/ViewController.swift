//
//  ViewController.swift
//  15-puzzle
//
//  Created by Gleb Engalychev on 08.12.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var labelMoves: UILabel!

    @IBOutlet var buttonCollectionGameBoardButtons: [UIButton]!
    
    var brain: GameBrain = GameBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brain.startNewGame()
        updateUI()
    }

    @IBAction func buttonNewGameTouchUpInside(_ sender: UIButton) {
        brain.startNewGame()
        updateUI()
    }
    
    @IBAction func buttonGameButtonTouchUpInside(_ sender: UIButton) {
        let index = buttonCollectionGameBoardButtons.firstIndex(where: {$0 == sender})!
        let convertedIndex = String((index - index % 4) / 4) + String(index % 4)
        
        if (brain.validateMove(convertedIndex)) {
            updateUI()
        }
    }
    
    @IBAction func buttonUndoMoveTouchUpInside(_ sender: UIButton) {
        brain.undoMove()
        updateUI()
    }
    
    private func updateUI() {
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
        
        labelMoves.text = String(brain.getMoves())
    }
}

