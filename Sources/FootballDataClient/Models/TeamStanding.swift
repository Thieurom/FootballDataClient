//
//  TeamStanding.swift
//  
//
//  Created by Doan Le Thieu on 27/02/2022.
//

import Foundation

public struct TeamStanding: Equatable {
    public let position: Int
    public let team: ShortTeam
    public let playedGames: Int
    public let won: Int
    public let draw: Int
    public let lost: Int
    public let points: Int
}
