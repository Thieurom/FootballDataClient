//
//  Team.swift
//  
//
//  Created by Doan Le Thieu on 27/02/2022.
//

import Foundation

public struct Team: Equatable {
    public let id: Int
    public let name: String
    public let shortName: String
    public let crestUrl: URL?
    public let founded: Int
    public let address: String
    public let venue: String
    public let websiteUrl: URL?
}

// A short (less information) version of `Team`
// TODO: Choose a `better` name
public struct ShortTeam: Equatable {
    public let id: Int
    public let name: String
    public let crestUrl: URL?
}
