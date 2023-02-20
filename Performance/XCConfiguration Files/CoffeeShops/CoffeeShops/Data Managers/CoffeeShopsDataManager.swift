//
//  CoffeeShopsDataManager.swift
//  CoffeeShops
//
//  Created by Gopal Gurram on 1/7/23.
//

import UIKit

protocol CoffeeShopsDataUpdatesDelegate: AnyObject {
    func modelUpdated()
    func fetchError(_ error: NetworkError)
}

protocol CoffeeShopsDataController {
    var coffeeShops: [Business] { get }
    var delegate: CoffeeShopsDataUpdatesDelegate? { get set }
    func fetchCoffeeShops(around location: Coordinates)
}

class CoffeeShopsDataManager: CoffeeShopsDataController {
    
    var coffeeShops = [Business]()
    let networkManager: NetworkManager
    var totalCoffeeShopsAvailable: UInt = 0
    private var coffeeShopInfo: BusinessInfo {
        let isIpad = UIScreen.main.traitCollection.userInterfaceIdiom == .pad
        let limit: UInt = isIpad ? 20 : 10
        
        return BusinessInfo(latitude: 37.775410, longitude: -122.398216, category: "coffee", limit: limit, sortBy: "distance", locale: "en_US", offset: UInt(coffeeShops.count))
    }
    
    var delegate: CoffeeShopsDataUpdatesDelegate?
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    convenience init() {
        self.init(networkManager: NetworkManager())
    }
    
    // Builds the relevant URL components from the values specified in the API.
    private func buildURL(endpoint: API) -> URLComponents {
        var components = URLComponents()
        components.scheme = endpoint.scheme.rawValue
        components.host = endpoint.baseURL
        components.path = endpoint.path
        components.queryItems = endpoint.parameters
        
        return components
    }
        
    func fetchCoffeeShops(around location: Coordinates) {
        let endpoint = CoffeeShopsAPI.getCoffeeShops(environment: .secure, endpoint: .businesses, shopsInfo: coffeeShopInfo)
        
        let components = buildURL(endpoint: endpoint)
        guard let url = components.url
        else {
            delegate?.fetchError(.invalidURL)
            
            return
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endpoint.method.rawValue
        urlRequest.addValue("Bearer \(AppEnvironment.apiKey)", forHTTPHeaderField: "Authorization")
        
        networkManager.dataTask(with: urlRequest) { [weak self] (result: Result<BusinessSearchResponse, NetworkError>) in
            guard let self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self.coffeeShops.append(contentsOf: response.businesses)
                    self.totalCoffeeShopsAvailable = response.total
                    self.delegate?.modelUpdated()
                case .failure(let error):
                    guard self.coffeeShops.count == 0 else { return } //ignore error if we have restaurants
                    
                    self.delegate?.fetchError(error)
                }
            }
        }
    }
}
