//
//  Standing.swift
//  
//
//  Created by Doan Le Thieu on 27/02/2022.
//

import Foundation

public struct Standing: Equatable {
    public let position: Int
    public let team: ShortTeam
    public let playedGames: Int
    public let won: Int
    public let draw: Int
    public let lost: Int
    public let points: Int

    public init(position: Int,
                team: ShortTeam,
                playedGames: Int,
                won: Int,
                draw: Int,
                lost: Int,
                points: Int) {
        self.position = position
        self.team = team
        self.playedGames = playedGames
        self.won = won
        self.draw = draw
        self.lost = lost
        self.points = points
    }
}
