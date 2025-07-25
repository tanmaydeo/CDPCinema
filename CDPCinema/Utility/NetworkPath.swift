//
//  NetworkPath.swift
//  CDPCinema
//
//  Created by Tanmay Deo on 25/05/25.
//

import Foundation

enum NetworkEnvironment {
    case testing
    case production
}

enum EndpointItem {
    case movies
    case tvShows
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

final class NetworkPath {
    
    static let shared = NetworkPath()
    
    private init() {}
    
    private var networkEnvironment: NetworkEnvironment = .production
    private var endpointItem: EndpointItem = .movies
    private var authorizationToken = AppConstants.authorizationToken
    
    var baseURL: String {
        switch networkEnvironment {
        case .testing:
            return ""
        case .production:
            return "https://api.themoviedb.org"
        }
    }
    
    var relativePath: String {
        switch endpointItem {
        case .movies:
            return "/3/movie/popular"
        case .tvShows:
            return "/3/tv"
        }
    }
    
    private var queryParams: [String: Any] = [
        "include_adult": "true",
        "include_video": "true",
        "language": "en-US",
        "api_key" : "\(AppConstants.apiKey)"
    ]
    
    var headers: [String: String] {
        return [
            "Authorization": "Bearer \(authorizationToken)"
        ]
    }
    
    func fullURLString(for endpoint: EndpointType) -> String {
        let path = endpoint.path
        let queryParams = endpoint.queryParams
        let queryString = queryParams
            .map { "\($0.key)=\("\($0.value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")" }
            .joined(separator: "&")
        return baseURL + path + "?" + queryString
    }
    
    func updateNetworkEnvironment(to environment: NetworkEnvironment) {
        self.networkEnvironment = environment
    }
    
    func updateEndpointItem(to item: EndpointItem) {
        self.endpointItem = item
    }
}

enum EndpointType {
    case popularMovies(page: Int)
    case searchMovies(query: String, page: Int)
    case genreList
    
    var path: String {
        switch self {
        case .popularMovies:
            return "/3/movie/popular"
        case .searchMovies:
            return "/3/search/movie"
        case .genreList:
            return "/3/genre/movie/list"
        }
    }
    
    var queryParams: [String: Any] {
        switch self {
        case .popularMovies(let page):
            return [
                "include_adult": "true",
                "include_video": "true",
                "language": "en-US",
                "api_key": AppConstants.apiKey,
                "page": page
            ]
        case .searchMovies(let query, let page):
            return [
                "language": "en-US",
                "api_key": AppConstants.apiKey,
                "query": query,
                "page": page
            ]
        case .genreList:
            return [
                "language": "en-US",
                "api_key": AppConstants.apiKey
            ]
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
}

