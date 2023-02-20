//
//  NetworkError.swift
//  CoffeeShops
//
//  Created by Gopal Gurram on 1/7/23.
//

import Foundation

enum NetworkError: String, Error {
    case invalidURL = "This url is invalid. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
}
