//
//  GameBrain.swift
//  15-puzzle
//
//  Created by Gleb Engalychev on 04.01.2022.
//

import Foundation

class GameBrain {
    private var gameBoard: [[String]] = []
    private var currentBlankTileLocation = ""
    private var moves = 0
    private var previousMoves: [String] = []
    
    func getGameBoard() -> [[String]] {
        return gameBoard
    }
    
    func getMoves() -> Int {
        return moves
    }
    
    func startNewGame() {
        gameBoard = getCompleteGameBoard()
        currentBlankTileLocation = "33"
        moves = 0
        previousMoves = []
        shuffle()
    }
    
    func validateMove(_ buttonTitle: String) -> Bool {
        let row = getButtonRow(buttonTitle)
        let col = getButtonCol(buttonTitle)
        
        if (gameBoard[row][col] == "X") {
            return false
        }
        
        let rowBlankTile = getButtonRow(currentBlankTileLocation)
        let colBlankTile = getButtonCol(currentBlankTileLocation)
        
        if ((rowBlankTile - row == 1 && colBlankTile == col) ||
            (rowBlankTile - row == -1 && colBlankTile == col) ||
            (rowBlankTile == row && colBlankTile - col == 1) ||
            (rowBlankTile == row && colBlankTile - col == -1)) {
            
            previousMoves.append(currentBlankTileLocation)
            swapButton(rowPressed: row, colPressed: col, blankTileRow: rowBlankTile, blankTileCol: colBlankTile)
            moves += 1
            
            return true
        }
        
        return false
    }
    
    private func getCompleteGameBoard() -> [[String]] {
        let gameBoard = [
            ["00", "01", "02", "03"],
            ["10", "11", "12", "13"],
            ["20", "21", "22", "23"],
            ["30", "31", "32", "X"]
        ]
        
        return gameBoard
    }
    
    public func undoMove() {
        if (previousMoves.count <= 0) {
            return
        }
        
        let previousMove = previousMoves.last!
        
        let row = getButtonRow(previousMove)
        let col = getButtonCol(previousMove)
        
        let rowBlankTile = getButtonRow(currentBlankTileLocation)
        let colBlankTile = getButtonCol(currentBlankTileLocation)
        
        swapButton(rowPressed: row, colPressed: col, blankTileRow: rowBlankTile, blankTileCol: colBlankTile)
        
        moves -= 1
        currentBlankTileLocation = previousMove
        previousMoves.removeLast()
    }
    
    private func getButtonRow(_ buttonTitle: String) -> Int {
        let first = String(buttonTitle.first!)
        return Int(first)!
    }
    
    private func getButtonCol(_ buttonTitle: String) -> Int {
        let last = String(buttonTitle.last!)
        return Int(last)!
    }
    
    private func swapButton(rowPressed: Int, colPressed: Int, blankTileRow: Int, blankTileCol: Int) {
        
        currentBlankTileLocation = String(rowPressed) + String(colPressed)
        let pressed = gameBoard[rowPressed][colPressed]
        gameBoard[rowPressed][colPressed] = "X"
        gameBoard[blankTileRow][blankTileCol] = pressed
    }
    
    private func shuffle() {
        var i = 100
        while i > 0 {
            randomMove()
            i -= 1
        }
    }
    
    private func randomMove() {
        let rowOrCol = Int.random(in: 0..<2)
        var change = 0
        
        let rowBlankTile = getButtonRow(currentBlankTileLocation)
        let colBlankTile = getButtonCol(currentBlankTileLocation)
        
        if (rowOrCol == 0) {
            change = rowBlankTile
        } else {
            change = colBlankTile
        }
        
        while true {
            if (Int.random(in: 0..<2) == 0) {
                change += 1
            } else {
                change -= 1
            }
            
            let borderRange = 0...3
            
            if (borderRange.contains(change)) {
                break
            }
        }
        
        if (rowOrCol == 0) {
            swapButton(rowPressed: change, colPressed: colBlankTile, blankTileRow: rowBlankTile, blankTileCol: colBlankTile)
        } else {
            swapButton(rowPressed: rowBlankTile, colPressed: change, blankTileRow: rowBlankTile, blankTileCol: colBlankTile)
        }
    }
}
