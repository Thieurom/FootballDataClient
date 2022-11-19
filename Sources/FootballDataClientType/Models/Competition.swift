//
//  Competition.swift
//  FootballDataClient
//
//  Created by Doan Le Thieu on 05/03/2022.
//

import Foundation

public struct Competition: Equatable {

    public let id: Int
    public let name: String
    public let ensignUrl: URL?
    public let currentSeason: Season?

    public init(id: Int, name: String, ensignUrl: URL? = nil, currentSeason: Season? = nil) {
        self.id = id
        self.name = name
        self.ensignUrl = ensignUrl
        self.currentSeason = currentSeason
    }
}
