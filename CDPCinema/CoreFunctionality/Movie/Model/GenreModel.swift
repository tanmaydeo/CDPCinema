//
//  GenreModel.swift
//  CDPCinema
//
//  Created by Tanmay Deo on 26/05/25.
//

import Foundation

struct GenreResponse: Decodable {
    let genres: [Genre]
}

struct Genre: Decodable {
    let id: Int
    let name: String
    
    static var genreMap: [Int: String] = [:]
}
