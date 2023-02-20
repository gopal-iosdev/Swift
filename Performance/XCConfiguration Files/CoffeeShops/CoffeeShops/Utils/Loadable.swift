//
//  Loadable.swift
//  CoffeeShops
//
//  Created by Gopal Gurram on 1/7/23.
//

import UIKit

protocol Loadable: AnyObject {
    var containerView: UIView? { get set }
    func showLoadingView()
    func hideLoadingView()
    func showEmptyStateView(with message: String, in view: UIView)
}

extension Loadable where Self: UIViewController {
    func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        
        guard let containerView
        else { return }
        
        view.addSubview(containerView)
        
        containerView.backgroundColor = .systemBackground
        containerView.alpha = 0
        
        UIView.animate(withDuration: 0.25) {
            self.containerView?.alpha = 0.8
        }
        
        let activityIndicator = UIActivityIndicatorView(style: .large)
        containerView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
        
        activityIndicator.startAnimating()
    }
    
    func hideLoadingView() {
        containerView?.removeFromSuperview()
        containerView = nil
    }
    
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = EmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
}
