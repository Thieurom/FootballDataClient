//
//  Resource.swift
//  
//
//  Created by Doan Le Thieu on 27/02/2022.
//

import Foundation

enum Resource {
    case team(teamId: Int)
    case standing(competitionId: Int)
}

extension Resource {
    var url: URL {
        URL(string: Resource.basePath + path)!
    }

    private static let basePath = "https://api.football-data.org/v2/"

    private var path: String {
        switch self {
        case .team(let teamId):
            return "teams/\(teamId)"
        case .standing(let competitionId):
            return "competitions/\(competitionId)/standings"
        }
    }
}
