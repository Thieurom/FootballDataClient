//
//  TeamResponse.swift
//  FootballDataClient
//
//  Created by Doan Le Thieu on 27/02/2022.
//

import FootballDataClientType
import Foundation

struct TeamResponse: Decodable {

    let id: Int
    let name: String
    let shortName: String
    let crestUrl: URL?
    let founded: Int
    let address: String
    let venue: String
    let websiteUrl: URL?

    private enum CodingKeys: String, CodingKey {
        case id, name, shortName, crestUrl, address, founded, venue
        case websiteUrl = "website"
    }

    func toTeam() -> Team {
        return .init(
            id: id,
            name: name,
            shortName: shortName,
            crestUrl: crestUrl,
            founded: founded,
            address: address,
            venue: venue,
            websiteUrl: websiteUrl
        )
    }
}

struct ShortTeamResponse: Decodable {

    let id: Int
    let name: String
    let crestUrl: URL?

    func toShortTeam() -> ShortTeam {
        return .init(
            id: id,
            name: name,
            crestUrl: crestUrl
        )
    }
}
