//
//  APIService.swift
//  iOS Concurrency
//
//  Created by Gopal Gurram on 1/10/23.
//

import Foundation

struct APIService {
    let urlString: String
    
    func getJSON<T: Decodable>(dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
                               keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys) async throws -> T {
        guard
            let url = URL(string: urlString)
        else {
            throw APIError.invalidURL
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let httpResponse = response as? HTTPURLResponse,
                    httpResponse.statusCode == 200
                else {
                    continuation.resume(with: .failure(APIError.invalidResponseStatus))
                    return
                }
                guard
                    error == nil
                else {
                    continuation.resume(with: .failure(APIError.dataTaskError(error!.localizedDescription)))
                    return
                }
                guard
                    let data1 = data
                else {
                    continuation.resume(with: .failure(APIError.corruptData))
                    return
                }
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = dateDecodingStrategy
                decoder.keyDecodingStrategy = keyDecodingStrategy
                do {
                    let decodedData = try decoder.decode(T.self, from: data1)
                    continuation.resume(with: .success(decodedData))
                } catch {
                    continuation.resume(with: .failure(APIError.decodingError(error.localizedDescription)))
                }
                
            }
            .resume()
        }
    }
}

enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponseStatus
    case dataTaskError(String)
    case corruptData
    case decodingError(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("The endpoint URL is invalid", comment: "")
        case .invalidResponseStatus:
            return NSLocalizedString("The API failed to issue a valid response", comment: "")
        case .dataTaskError(let string):
            return string
        case .corruptData:
            return NSLocalizedString("The data provided appears to be corrupt", comment: "")
        case .decodingError(let string):
            return string
        }
    }
}
