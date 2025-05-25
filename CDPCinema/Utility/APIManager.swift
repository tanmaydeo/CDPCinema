//
//  APIManager.swift
//  CDPCinema
//
//  Created by Tanmay Deo on 25/05/25.
//

import Foundation
import Alamofire

enum NetworkError: Error {
    case invalidURL
    case invalidBody
    case invalidData
    case customError(Error)
    
    var localizedDescription : String {
        switch self {
        case .invalidURL:
            return "The provided URL is not a valid URL"
        case .invalidBody:
            return "The request body could not be serialized into JSON due to improper structrue."
        case .invalidData:
            return "The response data from the server is not proper."
        case .customError(let error):
            return "Custom error : \(error)"
        }
    }
}

final class APIManager {
    
    static let sharedInstance = APIManager()
    private init() {}
    
    // MARK: - Alamofire Session with SSL Pinning
    private lazy var session: Session = {
        let certificates = Bundle.main.paths(forResourcesOfType: "cer", inDirectory: nil).compactMap {
            SecCertificateCreateWithData(nil, try! Data(contentsOf: URL(fileURLWithPath: $0)) as CFData)
        }
        
        let serverTrustPolicies: [String: ServerTrustEvaluating] = [
            "api.themoviedb.org": PinnedCertificatesTrustEvaluator(certificates: certificates, acceptSelfSignedCertificates: false, performDefaultValidation: true, validateHost: true)
        ]
        
        let serverTrustManager = ServerTrustManager(evaluators: serverTrustPolicies)
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        
        return Session(configuration: configuration, serverTrustManager: serverTrustManager)
    }()
    
    func performRequest<T: Decodable>(url: String, headers: [String: String] = [:],objectType: T.Type,success: @escaping (_ responseData: T) -> Void,failure: @escaping (_ error: NetworkError) -> Void) {
        guard let apiURL = URL(string: url) else {
            failure(.invalidURL)
            return
        }
        
        let afHeaders = HTTPHeaders(headers)
        
        session.request(apiURL, method: .get, headers: afHeaders)
            .responseDecodable(of: objectType) { response in
                guard let statusCode = response.response?.statusCode else {
                    failure(.invalidData)
                    return
                }
                
                switch statusCode {
                case 200..<300:
                    if let value = response.value {
                        success(value)
                    } else if let error = response.error {
                        failure(.customError(error))
                    }
                default:
                    failure(.customError(AFError.responseValidationFailed(reason: .unacceptableStatusCode(code: statusCode))))
                }
            }
    }
}
