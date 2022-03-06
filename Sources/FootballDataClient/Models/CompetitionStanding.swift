//
//  CompetitionStanding.swift
//  
//
//  Created by Doan Le Thieu on 27/02/2022.
//

import Foundation

public struct CompetitionStanding: Equatable {
    public let competition: Competition
    public let season: Season
    public let table: [TeamStanding]
}
