//
//  MatchResponse.swift
//  
//
//  Created by Doan Le Thieu on 01/03/2022.
//

import Foundation

// MARK: - /competitions/{id}/matches

struct CompetitionMatchesResponse: Decodable {
    let competition: CompetitionResponse
    let matches: [ACompetitionMatchResponse]
}

struct ACompetitionMatchResponse: Decodable {
    let id: Int
    let season: SeasonResponse
    let date: Date
    let matchDay: Int
    let status: Match.Status?
    let lastUpdated: Date
    let homeTeam: ShortTeamResponse
    let awayTeam: ShortTeamResponse
    let score: MatchScoreResponse

    private enum CodingKeys: String, CodingKey {
        case id, season, status, lastUpdated, homeTeam, awayTeam, score
        case matchDay = "matchday"
        case date = "utcDate"
    }

    func toMatch(of competition: CompetitionResponse) -> Match {
        return .init(
            id: id,
            competitionId: competition.id,
            competitionName: competition.name,
            season: season.toSeason(),
            date: date,
            matchDay: matchDay,
            status: status ?? .scheduled,
            lastUpdated: lastUpdated,
            homeTeam: homeTeam.toShortTeam(),
            awayTeam: awayTeam.toShortTeam(),
            score: score.toMatchScore()
        )
    }
}

// MARK: - /teams/{id}/matches

struct TeamMatchesResponse: Decodable {
    let matches: [ATeamMatchResponse]
}

struct ATeamMatchResponse: Decodable {
    let id: Int
    let competition: CompetitionResponse
    let season: SeasonResponse
    let date: Date
    let matchDay: Int
    let status: Match.Status?
    let lastUpdated: Date
    let homeTeam: ShortTeamResponse
    let awayTeam: ShortTeamResponse
    let score: MatchScoreResponse

    private enum CodingKeys: String, CodingKey {
        case id, competition, season, status, lastUpdated, homeTeam, awayTeam, score
        case matchDay = "matchday"
        case date = "utcDate"
    }

    func toMatch() -> Match {
        return .init(
            id: id,
            competitionId: competition.id,
            competitionName: competition.name,
            season: season.toSeason(),
            date: date,
            matchDay: matchDay,
            status: status ?? .scheduled,
            lastUpdated: lastUpdated,
            homeTeam: homeTeam.toShortTeam(),
            awayTeam: awayTeam.toShortTeam(),
            score: score.toMatchScore()
        )
    }

    func toMatch(head2head: Head2HeadResponse) -> Match {
        return .init(
            id: id,
            competitionId: competition.id,
            competitionName: competition.name,
            season: season.toSeason(),
            date: date,
            matchDay: matchDay,
            status: status ?? .scheduled,
            lastUpdated: lastUpdated,
            homeTeam: head2head.homeTeam.toShortTeam(),
            awayTeam: head2head.awayTeam.toShortTeam(),
            score: score.toMatchScore()
        )
    }
}

// MARK: - /matches/{id}

struct MatchResponse: Decodable {
    let head2head: Head2HeadResponse
    let match: ATeamMatchResponse
}

struct Head2HeadResponse: Decodable {
    let homeTeam: ShortTeamResponse
    let awayTeam: ShortTeamResponse
}

// MARK: - Common

struct MatchScoreResponse: Decodable {
    let halfTime: ScoreResponse
    let fullTime: ScoreResponse
    let extraTime: ScoreResponse
    let penalties: ScoreResponse

    func toMatchScore() -> MatchScore {
        return .init(
            halfTime: halfTime.toScore(),
            fullTime: fullTime.toScore(),
            extraTime: extraTime.toScore(),
            penalties: penalties.toScore()
        )
    }
}

struct ScoreResponse: Decodable {
    let homeTeam: Int?
    let awayTeam: Int?

    func toScore() -> Score {
        .init(homeTeam: homeTeam, awayTeam: awayTeam)
    }
}
