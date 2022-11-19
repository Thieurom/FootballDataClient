//
//  CompetitionStanding.swift
//  FootballDataClient
//
//  Created by Doan Le Thieu on 27/02/2022.
//

public struct CompetitionStanding: Equatable {

    public let competition: Competition
    public let season: Season
    public let table: [TeamStanding]

    public init(competition: Competition, season: Season, table: [TeamStanding]) {
        self.competition = competition
        self.season = season
        self.table = table
    }
}
