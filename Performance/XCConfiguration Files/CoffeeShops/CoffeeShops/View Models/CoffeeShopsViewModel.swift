//
//  CoffeeShopsViewModel.swift
//  CoffeeShops
//
//  Created by Gopal Gurram on 1/8/23.
//

import UIKit

enum CoffeeShopsViewState {
    case loading
    case error
    case emptyState
    case updatesAvailable
}

protocol CoffeeShopsFetchable {
    var viewState: CoffeeShopsViewState { get }
    
    func fetchCoffeeShops()
    func fetchNextPage()
}

protocol CoffeeShopsPresentable {
    var coffeeShopsCount: Int { get }
    
    func coffeeShopName(for indexPath: IndexPath) -> String
    func coffeeShopAddress(for indexPath: IndexPath) -> String
    func coffeeShopPrice(for indexPath: IndexPath) -> String
    func coffeeShopRating(for indexPath: IndexPath) -> String
    func coffeeShopImageUrl(for indexPath: IndexPath) -> String
}

class CoffeeShopsViewModel: CoffeeShopsFetchable {
    enum Section {
        case main
    }
    
    static let envoyHQCoordinates = Coordinates(latitude: 37.775410, longitude: -122.398216)
    
    let emptyStateInfoMessage = NSLocalizedString("No Coffee Shops near by", comment: "Placeholder text when no coffee shops are found")
    let title = NSLocalizedString("Coffee Shops", comment: "Coffee Shops near Envoy HQ")
    let alertTitle = NSLocalizedString("Something went wrong", comment: "Placeholder text when error is encountered")
    let okString = NSLocalizedString("Ok", comment: "Action text to dismiss alert popup")
    let retryString = NSLocalizedString("Retry", comment: "Action text to refetch coffee shops list")
    
    var viewState: CoffeeShopsViewState = .loading {
        didSet {
            updateUI?()
        }
    }
    var alertMessage = ""
    
    private var dataController: CoffeeShopsDataController
    var updateUI: (() -> Void)?
    
    init(coffeeShopsData: CoffeeShopsDataController) {
        self.dataController = coffeeShopsData
    }
    
    convenience init() {
        self.init(coffeeShopsData: CoffeeShopsDataManager())
    }
    
    func fetchCoffeeShops() {
        dataController.delegate = self
        dataController.fetchCoffeeShops(around: Self.envoyHQCoordinates)
    }
    
    func fetchNextPage() {
        dataController.fetchCoffeeShops(around: Self.envoyHQCoordinates)
    }
}

extension CoffeeShopsViewModel: CoffeeShopsPresentable {
    var coffeeShopsCount: Int {
        dataController.coffeeShops.count
    }
    
    func coffeeShopName(for indexPath: IndexPath) -> String {
        let coffeeShop = dataController.coffeeShops[indexPath.row]
        return coffeeShop.name
    }
    
    func coffeeShopAddress(for indexPath: IndexPath) -> String {
        let coffeeShop = dataController.coffeeShops[indexPath.row]
        return coffeeShop.address.street + " " + coffeeShop.address.city
    }
    
    func coffeeShopPrice(for indexPath: IndexPath) -> String {
        let coffeeShop = dataController.coffeeShops[indexPath.row]
        return coffeeShop.price?.rawValue ?? ""
    }
    
    func coffeeShopRating(for indexPath: IndexPath) -> String {
        let coffeeShop = dataController.coffeeShops[indexPath.row]
        return "\(coffeeShop.rating) " + "\u{2B50}"
    }
    
    func coffeeShopImageUrl(for indexPath: IndexPath) -> String {
        let coffeeShop = dataController.coffeeShops[indexPath.row]
        return coffeeShop.imageUrl
    }
    
}

extension CoffeeShopsViewModel: CoffeeShopsDataUpdatesDelegate {
    func modelUpdated() {
        viewState = .updatesAvailable
    }
    
    func fetchError(_ error: NetworkError) {
        alertMessage = error.rawValue
        viewState = dataController.coffeeShops.isEmpty ? .emptyState : .error
    }
}
