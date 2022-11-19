//
//  Match.swift
//  FootballDataClient
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

    public init(id: Int, competition: Competition, season: Season, date: Date, matchDay: MatchDay, status: Match.Status, lastUpdated: Date, homeTeam: ShortTeam, awayTeam: ShortTeam, score: MatchScore) {
        self.id = id
        self.competition = competition
        self.season = season
        self.date = date
        self.matchDay = matchDay
        self.status = status
        self.lastUpdated = lastUpdated
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
        self.score = score
    }

    public let id: Int
    public let competition: Competition
    public let season: Season
    public let date: Date
    public let matchDay: MatchDay
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

    public init(halfTime: Score, fullTime: Score, extraTime: Score, penalties: Score) {
        self.halfTime = halfTime
        self.fullTime = fullTime
        self.extraTime = extraTime
        self.penalties = penalties
    }
}

// TODO: Choose a better name
public struct Score: Equatable {

    public let homeTeam: Int?
    public let awayTeam: Int?

    public init(homeTeam: Int? = nil, awayTeam: Int? = nil) {
        self.homeTeam = homeTeam
        self.awayTeam = awayTeam
    }
}

public struct Goal: Equatable {

    public let minute: Int
    public let extraTime: Int?
    public let team: ShortTeam
    public let scorer: Player

    public init(minute: Int, extraTime: Int? = nil, team: ShortTeam, scorer: Player) {
        self.minute = minute
        self.extraTime = extraTime
        self.team = team
        self.scorer = scorer
    }
}

public struct Player: Equatable {

    public let id: Int
    public let name: String

    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}
