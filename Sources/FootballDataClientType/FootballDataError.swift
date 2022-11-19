//
//  ApiError.swift
//  FootballDataClient
//
//  Created by Doan Le Thieu on 27/02/2022.
//

import Foundation

public enum FootballDataError: Error, Equatable {

    case badRequest
    case badData
    case unknown
}
