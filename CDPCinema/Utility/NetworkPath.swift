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
    
    func fullURLString(pageNo : Int) -> String {
        self.queryParams["page"] = pageNo
        var queryString = ""
        if !queryParams.isEmpty {
            queryString = queryParams.map { "\($0.key)=\($0.value)" }.joined(separator: "&")
        }
        return baseURL + relativePath + "?" + queryString
    }
    
    func updateNetworkEnvironment(to environment: NetworkEnvironment) {
        self.networkEnvironment = environment
    }
    
    func updateEndpointItem(to item: EndpointItem) {
        self.endpointItem = item
    }
}
