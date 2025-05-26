//
//  SearchViewModel.swift
//  CDPCinema
//
//  Created by Tanmay Deo on 26/05/25.
//

import Foundation

class SearchViewModel {
    
    func searchMovies(query: String, pageNo: Int, completionHandler: @escaping ([Movie]?) -> Void) {
        let url = NetworkPath.shared.fullURLString(for: .searchMovies(query: query, page: pageNo))
        print("Search URL: \(url)")
        
        APIManager.sharedInstance.performRequest(
            url: url,
            headers: NetworkPath.shared.headers,
            objectType: MovieModel.self
        ) { responseData in
            let resultsArray = Array(responseData.results)
            completionHandler(resultsArray)
        } failure: { error in
            print("Search Error: \(error.localizedDescription)")
        }
    }
}

