//
//  GameBrainDTO.swift
//  15-puzzle
//
//  Created by Gleb Engalychev on 11.01.2022.
//

import Foundation

struct GameBrainDTO: Codable {
    var gameBoard: [[String]]
    var currentBlankTileLocation: String
    var moves: Int
    var time: Int
    var previousMoves: [String]
}
