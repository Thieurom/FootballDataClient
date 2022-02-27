//
//  CompetitionStanding.swift
//  
//
//  Created by Doan Le Thieu on 27/02/2022.
//

import Foundation

public struct CompetitionStanding: Equatable {
    public let competitionId: Int
    public let competitionName: String
    public let season: Season
    public let table: [Standing]

    public init(competitionId: Int,
                competitionName: String,
                season: Season,
                table: [Standing]) {
        self.competitionId = competitionId
        self.competitionName = competitionName
        self.season = season
        self.table = table
    }
}