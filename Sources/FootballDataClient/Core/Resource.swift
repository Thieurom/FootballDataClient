//
//  Resource.swift
//  
//
//  Created by Doan Le Thieu on 27/02/2022.
//

import Foundation

protocol ResourceType {
    var path: String { get }
}

enum TeamResource: ResourceType {
    case team(id: Int)
    case matches(teamId: Int)

    static let basePath = "teams"

    var path: String {
        switch self {
        case .team(let id):
            return "\(Self.basePath)/\(id)"
        case .matches(teamId: let teamId):
            return "\(Self.basePath)/\(teamId)/matches"
        }
    }
}

enum CompetitionResource: ResourceType {
    case competition(id: Int)
    case standing(competitionId: Int)
    case matches(competitionId: Int)

    static let basePath = "competitions"

    var path: String {
        switch self {
        case .competition(let id):
            return "\(Self.basePath)/\(id)"
        case .standing(competitionId: let competitionId):
            return "\(Self.basePath)/\(competitionId)/standings"
        case .matches(competitionId: let competitionId):
            return "\(Self.basePath)/\(competitionId)/matches"
        }
    }
}

enum MatchResource: ResourceType {
    case match(id: Int)

    static let basePath = "matches"

    var path: String {
        switch self {
        case .match(id: let id):
            return "\(Self.basePath)/\(id)"
        }
    }
}
