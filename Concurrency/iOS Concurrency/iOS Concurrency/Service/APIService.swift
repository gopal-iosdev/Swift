//
//  APIService.swift
//  iOS Concurrency
//
//  Created by Gopal Gurram on 1/10/23.
//

import Foundation

struct APIService {
    let urlString: String
    
    func getJSON<T: Decodable>(dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys, completion: @escaping (Result<T, APIError>) -> Void) {
        guard let url = URL(string: urlString)
        else {
            completion(.failure(.invalidURL))
            
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            let result: Result<T, APIError>
            
            defer {
                completion(result)
            }
            
            guard let httpsResponse = response as? HTTPURLResponse,
                  httpsResponse.statusCode == 200
            else {
                result = .failure(.invalidResponseStatus)
                
                return
            }
            
            guard error == nil
            else {
                result = .failure(.dataTaskError)
                
                return
            }
            
            guard let data
            else {
                result = .failure(.corruptData)
                
                return
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy
            
            do {
                let decodedData = try decoder.decode(T.self, from: data)
                
                result = .success(decodedData)
            } catch {
                dump(error)
                result = .failure(.decodingError)
            }
        }
    }
}

enum APIError: Error {
    case invalidURL
    case invalidResponseStatus
    case dataTaskError
    case corruptData
    case decodingError
}
