//
//  Season.swift
//  FootballDataClient
//
//  Created by Doan Le Thieu on 27/02/2022.
//

public struct Season: Equatable {

    public let id: Int
    public let currentMatchday: MatchDay?

    public init(id: Int, currentMatchday: MatchDay? = nil) {
        self.id = id
        self.currentMatchday = currentMatchday
    }
}
