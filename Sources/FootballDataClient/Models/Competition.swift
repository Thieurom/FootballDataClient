//
//  Competition.swift
//  
//
//  Created by Doan Le Thieu on 05/03/2022.
//

import Foundation

public struct Competition: Equatable {
    public let id: Int
    public let name: String
    public let ensignUrl: URL?
    public let currentSeason: Season?
}
