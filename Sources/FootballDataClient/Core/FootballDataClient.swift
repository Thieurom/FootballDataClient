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

    private let jsonDecoder = JSONDecoder()

    /// Init the client with a token
    public init(apiToken: String) {
        self.apiToken = apiToken
    }

    /// Fetch the team from a given id
    public func fetchTeam(teamId: Int) -> AnyPublisher<Team, ApiError> {
        let resource = Resource.team(teamId: teamId)
        let request = URLRequest(url: resource.url)
        return makeRequest(request, from: TeamResponse.self) {
            $0.toTeam()
        }
    }

    /// Fetch competition standing from a given competition's id
    public func fetchStanding(competitionId: Int) -> AnyPublisher<CompetitionStanding, ApiError> {
        let resource = Resource.standing(competitionId: competitionId)
        let request = URLRequest(url: resource.url)

        return makeRequest(request, from: CompetitionStandingResponse.self) {
            $0.toCompetitionStanding()
        }
    }
}

// MARK: - Internal

extension FootballDataClient {
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
            .decode(type: R.self, decoder: jsonDecoder)
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
