//
//  MovieViewModel.swift
//  CDPCinema
//
//  Created by Tanmay Deo on 25/05/25.
//

import Foundation


class MovieViewModel {
    
    func getPopularMovies(pageNo : Int, completionHandler : @escaping ([Results]?, Int) -> Void) {
        let url = NetworkPath.shared.fullURLString(for: .popularMovies(page: pageNo))
        print(url)
        
        APIManager.sharedInstance.performRequest(url: url, headers: NetworkPath.shared.headers, objectType: MovieModel.self) { responseData in
            let resultsArray = Array(responseData.results)
            completionHandler(resultsArray, responseData.totalPages)
        } failure: { error in
            print("\(error.localizedDescription)")
        }
    }
    
    func fetchGenres(completionHandler: @escaping ([Genre]) -> Void) {
        let url = NetworkPath.shared.fullURLString(for: .genreList)
        print(url)
        
        APIManager.sharedInstance.performRequest(url: url, headers: NetworkPath.shared.headers, objectType: GenreResponse.self) { responseData in
            let genreArray = Array(responseData.genres)
            completionHandler(genreArray)
        } failure: { error in
            print("\(error.localizedDescription)")
        }
    }
}
