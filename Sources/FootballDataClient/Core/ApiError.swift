//
//  ApiError.swift
//  
//
//  Created by Doan Le Thieu on 27/02/2022.
//

import Foundation

public enum ApiError: Error, Equatable {
    case badRequest
    case badData
    case unknown
}
