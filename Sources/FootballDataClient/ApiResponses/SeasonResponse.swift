//
//  SeasonResponse.swift
//  
//
//  Created by Doan Le Thieu on 27/02/2022.
//

import Foundation

struct SeasonResponse: Decodable {
    let id: Int
    let currentMatchday: Int

    func toSeason() -> Season {
        return .init(id: id, currentMatchday: currentMatchday)
    }
}
