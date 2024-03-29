//
//  CompetitionStandingResponse.swift
//  FootballDataClient
//
//  Created by Doan Le Thieu on 27/02/2022.
//

import FootballDataClientType

struct CompetitionStandingResponse: Decodable {

    let competition: CompetitionResponse
    let season: SeasonResponse
    let standings: [StandingTableResponse]

    func toCompetitionStanding() -> CompetitionStanding {
        return .init(
            competition: competition.toCompetition(),
            season: season.toSeason(),
            table: (standings.first?.table ?? [])
                .map { $0.toStanding() }
        )
    }
}

struct StandingTableResponse: Decodable {

    let table: [StandingResponse]
}

struct StandingResponse: Decodable {

    let position: Int
    let team: ShortTeamResponse
    let playedGames: Int
    let won: Int
    let draw: Int
    let lost: Int
    let points: Int

    func toStanding() -> TeamStanding {
        return .init(
            position: position,
            team: team.toShortTeam(),
            playedGames: playedGames,
            won: won,
            draw: draw,
            lost: lost,
            points: points
        )
    }
}
