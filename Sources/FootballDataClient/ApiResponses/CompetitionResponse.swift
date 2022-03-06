//
//  CompetitionResponse.swift
//  
//
//  Created by Doan Le Thieu on 27/02/2022.
//

import Foundation

struct CompetitionResponse: Decodable {
    let id: Int
    let name: String
    let area: AreaResponse?
    let currentSeason: SeasonResponse?

    func toCompetition() -> Competition {
        return .init(
            id: id,
            name: name,
            ensignUrl: area?.ensignUrl,
            currentSeason: currentSeason?.toSeason()
        )
    }
}

struct AreaResponse: Decodable {
    let ensignUrl: URL?
}
