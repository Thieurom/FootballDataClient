//
//  FootballDataClient.swift
//  FootballDataClient
//
//  Created by Doan Le Thieu on 27/02/2022.
//

import Combine
import FootballDataClientType
import Foundation
import Pilot
import PilotType

public struct FootballDataClient {

    private let apiToken: String
    private let network: Pilot<FootballDataRoute>

    private static let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return dateFormatter
    }()

    private static let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()

    /// Init the client with an API token and optionally-provided `URLSession`
    public init(apiToken: String, urlSession: URLSession = .shared) {
        self.network = Pilot<FootballDataRoute>(session: urlSession)
        self.apiToken = apiToken
    }
}

extension FootballDataClient: FootballDataClientType {

    /// Fetch the competition from a given id
    public func fetchCompetition(competitionId: Int) -> AnyPublisher<Competition, FootballDataError> {
        return network
            .request(
                .competition(competitionId).withAuthToken(apiToken),
                target: CompetitionResponse.self,
                decoder: Self.jsonDecoder
            )
            .map { $0.toCompetition() }
            .mapError(\.asFootballDataError)
            .eraseToAnyPublisher()
    }

    /// Fetch competition standing from a given competition's id
    public func fetchStanding(competitionId: Int) -> AnyPublisher<CompetitionStanding, FootballDataError> {
        return network
            .request(
                .standingOfCompetition(competitionId).withAuthToken(apiToken),
                target: CompetitionStandingResponse.self,
                decoder: Self.jsonDecoder
            )
            .map { $0.toCompetitionStanding() }
            .mapError(\.asFootballDataError)
            .eraseToAnyPublisher()
    }

    /// Fetch the team from a given id
    public func fetchTeam(teamId: Int) -> AnyPublisher<Team, FootballDataError> {
        return network
            .request(
                .team(teamId).withAuthToken(apiToken),
                target: TeamResponse.self,
                decoder: Self.jsonDecoder
            )
            .map { $0.toTeam() }
            .mapError(\.asFootballDataError)
            .eraseToAnyPublisher()
    }

    /// Fetch the match from a given id
    public func fetchMatch(matchId: Int) -> AnyPublisher<Match, FootballDataError> {
        return network
            .request(
                .match(matchId).withAuthToken(apiToken),
                target: MatchResponse.self,
                decoder: Self.jsonDecoder
            )
            .map { $0.match.toMatch(head2head: $0.head2head) }
            .mapError(\.asFootballDataError)
            .eraseToAnyPublisher()
    }

    /// Fetch matches of a specific competition
    public func fetchMatches(competitionId: Int) -> AnyPublisher<[Match], FootballDataError> {
        return network
            .request(
                .matchesOfCompetition(competitionId).withAuthToken(apiToken),
                target: CompetitionMatchesResponse.self,
                decoder: Self.jsonDecoder
            )
            .map { response in response.matches.map { $0.toMatch(of: response.competition) } }
            .mapError(\.asFootballDataError)
            .flatMap { matches -> AnyPublisher<[Match], FootballDataError> in
                guard let first = matches.first else {
                    return Just(matches)
                        .setFailureType(to: FootballDataError.self)
                        .eraseToAnyPublisher()
                }

                return fetchMatch(matchId: first.id)
                    .map { match in
                        matches.map {
                            Match(
                                id: $0.id,
                                competition: match.competition,
                                season: $0.season,
                                date: $0.date,
                                matchDay: $0.matchDay,
                                status: $0.status,
                                lastUpdated: $0.lastUpdated,
                                homeTeam: $0.homeTeam,
                                awayTeam: $0.awayTeam,
                                score: $0.score
                            )
                        }
                    }
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }

    /// Fetch matches of a specific team
    public func fetchMatches(teamId: Int) -> AnyPublisher<[Match], FootballDataError> {
        return network
            .request(
                .matchesOfTeam(teamId).withAuthToken(apiToken),
                target: TeamMatchesResponse.self,
                decoder: Self.jsonDecoder
            )
            .map { $0.matches.map { $0.toMatch() } }
            .mapError(\.asFootballDataError)
            .eraseToAnyPublisher()
    }
}

extension PilotError {

    fileprivate var asFootballDataError: FootballDataError {
        switch self {
        case .decoding:
            return .badData
        case .designated:
            return .unknown
        case .underlying:
            return .badRequest
        }
    }
}
