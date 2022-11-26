//
//  FootballDataRoute.swift
//  FootballDataClient
//
//  Created by Doan Le Thieu on 19/11/2022.
//

import Foundation
import PilotType

struct FootballDataRoute: Route {

    static let xAuthTokenHeader = "X-Auth-Token"

    let baseURL = URL(string: "https://api.football-data.org/v2/")!
    let path: String
    let httpMethod: HttpMethod = .get
    private(set) var httpHeaders: HttpHeaders = [:]
    let parameters: Parameters? = nil
    let parameterEncoding: ParameterEncoding? = .json

    private init(competition competitionId: Int) {
        self.path = "competitions/\(competitionId)"
    }

    private init(standingOfCompetition competitionId: Int) {
        self.path = "competitions/\(competitionId)/standings"
    }

    private init(matchesOfCompetition competitionId: Int) {
        self.path = "matches/\(competitionId)"
    }

    private init(team teamId: Int) {
        self.path = "teams/\(teamId)"
    }

    private init(matchesOfTeam teamId: Int) {
        self.path = "teams/\(teamId)/matches"
    }

    private init(match matchId: Int) {
        self.path = "matches/\(matchId)"
    }

    func withAuthToken(_ token: String) -> FootballDataRoute {
        var copy = self
        copy.httpHeaders[Self.xAuthTokenHeader] = token
        return copy
    }
}

extension FootballDataRoute {

    static func competition(_ competitionId: Int) -> FootballDataRoute {
        return .init(competition: competitionId)
    }

    static func standingOfCompetition(_ competitionId: Int) -> FootballDataRoute {
        return .init(standingOfCompetition: competitionId)
    }

    static func matchesOfCompetition(_ competitionId: Int) -> FootballDataRoute {
        return .init(matchesOfCompetition: competitionId)
    }

    static func team(_ teamId: Int) -> FootballDataRoute {
        return .init(team: teamId)
    }

    static func matchesOfTeam(_ teamId: Int) -> FootballDataRoute {
        return .init(matchesOfTeam: teamId)
    }

    static func match(_ matchIt: Int) -> FootballDataRoute {
        return .init(match: matchIt)
    }
}
