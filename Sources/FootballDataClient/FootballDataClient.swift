//
//  FootballDataClient.swift
//  FootballDataClient
//
//  Created by Doan Le Thieu on 27/02/2022.
//

import Combine
import FootballDataClientType
import Foundation

public struct FootballDataClient {
    private let apiToken: String

    // Dependencies
    private let urlSession = URLSession.shared

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

    /// Init the client with a token
    public init(apiToken: String) {
        self.apiToken = apiToken
    }
}

// MARK: - Fetch `Competition`

extension FootballDataClient {
    /// Fetch the competition from a given id
    public func fetchCompetition(competitionId: Int) -> AnyPublisher<Competition, FootballDataError> {
        let resource = CompetitionResource.competition(id: competitionId)
        let url = makeUrl(for: resource)
        let request = URLRequest(url: url)

        return makeRequest(request, from: CompetitionResponse.self) {
            $0.toCompetition()
        }
    }
}

// MARK: - Fetch `Team`

extension FootballDataClient {
    /// Fetch the team from a given id
    public func fetchTeam(teamId: Int) -> AnyPublisher<Team, FootballDataError> {
        let resource = TeamResource.team(id: teamId)
        let url = makeUrl(for: resource)
        let request = URLRequest(url: url)
        
        return makeRequest(request, from: TeamResponse.self) {
            $0.toTeam()
        }
    }
}

// MARK: - Fetch `CompetitionStanding`

extension FootballDataClient {
    /// Fetch competition standing from a given competition's id
    public func fetchStanding(competitionId: Int) -> AnyPublisher<CompetitionStanding, FootballDataError> {
        let resource = CompetitionResource.standing(competitionId: competitionId)
        let url = makeUrl(for: resource)
        let request = URLRequest(url: url)

        return makeRequest(request, from: CompetitionStandingResponse.self) {
            $0.toCompetitionStanding()
        }
    }
}

// MARK: - Fetch `Match(es)`

extension FootballDataClient {
    /// Fetch the match from a given id
    public func fetchMatch(matchId: Int) -> AnyPublisher<Match, FootballDataError> {
        let resource = MatchResource.match(id: matchId)
        let url = makeUrl(for: resource)
        let request = URLRequest(url: url)

        return makeRequest(request, from: MatchResponse.self) { response in
            response.match.toMatch(head2head: response.head2head)
        }
    }

    /// Fetch matches of a specific competition
    public func fetchMatches(competitionId: Int) -> AnyPublisher<[Match], FootballDataError> {
        let resource = CompetitionResource.matches(competitionId: competitionId)
        let url = makeUrl(for: resource)
        let request = URLRequest(url: url)

        return makeRequest(request, from: CompetitionMatchesResponse.self) { response in
            response.matches.map { $0.toMatch(of: response.competition) }
        }
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
        let resource = TeamResource.matches(teamId: teamId)
        let url = makeUrl(for: resource)
        let request = URLRequest(url: url)

        return makeRequest(request, from: TeamMatchesResponse.self) {
            $0.matches.map { $0.toMatch() }
        }
    }
}

// MARK: - Internal

extension FootballDataClient {
    private func makeUrl(for resource: ResourceType) -> URL {
        let basePath = "https://api.football-data.org/v2/"
        return URL(string: basePath + resource.path)!
    }

    private func makeRequest<R: Decodable, M>(_ request: URLRequest, from type: R.Type, transform: @escaping (R) -> M) -> AnyPublisher<M, FootballDataError> {
        var request = request
        request.setValue(apiToken, forHTTPHeaderField: "X-Auth-Token")

        #if DEBUG
        print("[API] Request: \(request)\n\(request.allHTTPHeaderFields ?? [:])")
        #endif

        return urlSession.dataTaskPublisher(for: request)
            .handleEvents(receiveOutput: {
                #if DEBUG
                let statusCode = ($0.response as? HTTPURLResponse)?.statusCode
                let codeString = statusCode != nil ? "\(statusCode!) " : ""
                print("[API] Response: \(request)\n\(codeString)\(String(decoding: $0.data, as: UTF8.self))")
                #endif
            })
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw FootballDataError.unknown
                }

                guard (200..<300) ~= httpResponse.statusCode else {
                    throw FootballDataError.badRequest
                }

                return data
            }
            .decode(type: R.self, decoder: Self.jsonDecoder)
            .map { transform($0) }
            .mapError { error -> FootballDataError in
                if error is DecodingError {
                    #if DEBUG
                    print("DecodingError: \(error)")
                    #endif
                    return .badData
                }

                return (error as? FootballDataError) ?? .unknown
            }
            .eraseToAnyPublisher()
    }
}
