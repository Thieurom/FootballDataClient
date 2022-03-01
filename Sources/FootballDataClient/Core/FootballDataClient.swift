//
//  FootballDataClient.swift
//
//
//  Created by Doan Le Thieu on 27/02/2022.
//

import Combine
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

// MARK: - Fetch `Team`

extension FootballDataClient {
    /// Fetch the team from a given id
    public func fetchTeam(teamId: Int) -> AnyPublisher<Team, ApiError> {
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
    public func fetchStanding(competitionId: Int) -> AnyPublisher<CompetitionStanding, ApiError> {
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
    public func fetchMatch(matchId: Int) -> AnyPublisher<Match, ApiError> {
        let resource = MatchResource.match(id: matchId)
        let url = makeUrl(for: resource)
        let request = URLRequest(url: url)

        return makeRequest(request, from: MatchResponse.self) { response in
            response.match.toMatch(head2head: response.head2head)
        }
    }

    /// Fetch matches of a specific competition
    public func fetchMatches(competitionId: Int) -> AnyPublisher<[Match], ApiError> {
        let resource = CompetitionResource.matches(competitionId: competitionId)
        let url = makeUrl(for: resource)
        let request = URLRequest(url: url)

        return makeRequest(request, from: CompetitionMatchesResponse.self) { response in
            response.matches.map { $0.toMatch(of: response.competition) }
        }
    }

    /// Fetch matches of a specific team
    public func fetchMatches(teamId: Int) -> AnyPublisher<[Match], ApiError> {
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

    private func makeRequest<R: Decodable, M>(_ request: URLRequest, from type: R.Type, transform: @escaping (R) -> M) -> AnyPublisher<M, ApiError> {
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
                    throw ApiError.unknown
                }

                guard (200..<300) ~= httpResponse.statusCode else {
                    throw ApiError.badRequest
                }

                return data
            }
            .decode(type: R.self, decoder: Self.jsonDecoder)
            .map { transform($0) }
            .mapError { error -> ApiError in
                if error is DecodingError {
                    #if DEBUG
                    print("DecodingError: \(error)")
                    #endif
                    return .badData
                }

                return (error as? ApiError) ?? .unknown
            }
            .eraseToAnyPublisher()
    }
}
