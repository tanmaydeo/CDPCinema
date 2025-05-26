//
//  MovieModel.swift
//  CDPCinema
//
//  Created by Tanmay Deo on 25/05/25.
//

import Foundation
import RealmSwift

class MovieModel : Object, Decodable {
    @objc dynamic var page: Int = 0
    @objc dynamic var totalPages: Int = 0
    @objc dynamic var totalResults: Int = 0
    let results = List<Movie>()
    
    enum CodingKeys: String, CodingKey {
        
        case page = "page"
        case results = "results"
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        page = try values.decodeIfPresent(Int.self, forKey: .page) ?? 0
        totalPages = try values.decodeIfPresent(Int.self, forKey: .totalPages) ?? 0
        totalResults = try values.decodeIfPresent(Int.self, forKey: .totalResults) ?? 0
        if let resultsArray = try values.decodeIfPresent([Movie].self, forKey: .results) {
            results.append(objectsIn: resultsArray)
        }
    }
}

class Movie: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var originalTitle: String?
    @objc dynamic var overview: String?
    @objc dynamic var releaseDate: String?
    @objc dynamic var title: String?
    @objc dynamic var voteAverage: Double = 0
    @objc dynamic var voteCount: Int = 0
    @objc dynamic var posterPath: String?
    @objc dynamic var backdropPath: String?
    let genreIds = List<Int>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    var formattedReleaseDate: String? {
        guard let releaseDate = releaseDate else { return nil }
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "d MMMM yyyy"
        
        if let date = inputFormatter.date(from: releaseDate) {
            return outputFormatter.string(from: date)
        }
        return nil
    }
    
    var genreNames: String {
        let names = genreIds.compactMap { Genre.genreMap[$0] }
        return names.joined(separator: ", ")
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case originalTitle = "original_title"
        case overview = "overview"
        case releaseDate = "release_date"
        case title = "title"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
        originalTitle = try values.decodeIfPresent(String.self, forKey: .originalTitle)
        overview = try values.decodeIfPresent(String.self, forKey: .overview)
        releaseDate = try values.decodeIfPresent(String.self, forKey: .releaseDate)
        title = try values.decodeIfPresent(String.self, forKey: .title)
        voteAverage = try values.decodeIfPresent(Double.self, forKey: .voteAverage) ?? 0
        voteCount = try values.decodeIfPresent(Int.self, forKey: .voteCount) ?? 0
        posterPath = try values.decodeIfPresent(String.self, forKey: .posterPath)
        backdropPath = try values.decodeIfPresent(String.self, forKey: .backdropPath)
        if let genreIdsArray = try values.decodeIfPresent([Int].self, forKey: .genreIds) {
            genreIds.append(objectsIn: genreIdsArray)
        }
    }
}
