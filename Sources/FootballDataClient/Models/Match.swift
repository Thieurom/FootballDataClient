//
//  Match.swift
//  
//
//  Created by Doan Le Thieu on 01/03/2022.
//

import Foundation

public struct Match: Equatable {
    public enum Status: String, Decodable, Equatable {
        case scheduled = "SCHEDULED"
        case canceled = "CANCELLED"
        case postponed = "POSTPONED"
        case suspended = "SUSPENDED"
        case inPlay = "IN_PLAY"
        case paused = "PAUSED"
        case awarded = "AWARDED"
        case finished = "FINISHED"
    }

    public let id: Int
    public let competitionId: Int
    public let competitionName: String
    public let season: Season
    public let date: Date
    public let matchDay: Int
    public let status: Status
    public let lastUpdated: Date
    public let homeTeam: ShortTeam
    public let awayTeam: ShortTeam
    public let score: MatchScore
}

public struct MatchScore: Equatable {
    public let halfTime: Score
    public let fullTime: Score
    public let extraTime: Score
    public let penalties: Score
}

// TODO: Choose a better name
public struct Score: Equatable {
    public let homeTeam: Int?
    public let awayTeam: Int?
}

public struct Goal: Equatable {
    public let minute: Int
    public let extraTime: Int?
    public let team: ShortTeam
    public let scorer: Player
}

public struct Player: Equatable {
    public let id: Int
    public let name: String
}
