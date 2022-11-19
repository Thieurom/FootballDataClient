//
//  FootballDataClientType.swift
//  FootballDataClient
//
//  Created by Doan Le Thieu on 19/11/2022.
//

import Combine

public protocol FootballDataClientType {

    func fetchCompetition(competitionId: Int) -> AnyPublisher<Competition, FootballDataError>
    func fetchTeam(teamId: Int) -> AnyPublisher<Team, FootballDataError>
    func fetchStanding(competitionId: Int) -> AnyPublisher<CompetitionStanding, FootballDataError>
    func fetchMatch(matchId: Int) -> AnyPublisher<Match, FootballDataError>
    func fetchMatches(competitionId: Int) -> AnyPublisher<[Match], FootballDataError>
    func fetchMatches(teamId: Int) -> AnyPublisher<[Match], FootballDataError>
}
