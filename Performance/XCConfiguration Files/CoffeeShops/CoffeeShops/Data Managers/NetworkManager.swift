//
//  NetworkManager.swift
//  CoffeeShops
//
//  Created by Gopal Gurram on 1/7/23.
//

import Foundation

final class NetworkManager {
    
    @discardableResult
    func dataTask<T: Codable>(with url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) -> URLSessionDataTask {
        let request = URLRequest(url: url)
        return dataTask(with: request, completion: completion)
    }
    
    @discardableResult
    func dataTask<T: Codable>(with request: URLRequest, completion: @escaping (Result<T, NetworkError>) -> Void) -> URLSessionDataTask {
        
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: request) { data, response, error in
            
            let result: Result<T, NetworkError>
            
            defer {
                completion(result)
            }
            
            if let _ = error {
                result = .failure(.unableToComplete)
                
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200
            else {
                result = .failure(.invalidResponse)
                
                return
            }
            
            guard let data
            else {
                result = .failure(.invalidData)
                
                return
            }
            
            if let data = data as? T {
                result = .success(data)
                
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let model = try decoder.decode(T.self, from: data)
                
                result = .success(model)
            }
            catch {
                result = .failure(.invalidData)
            }
        }

        dataTask.resume()
        
        return dataTask
    }
}
