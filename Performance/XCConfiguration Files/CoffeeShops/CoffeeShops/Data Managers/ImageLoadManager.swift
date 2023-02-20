//
//  ImageLoadManager.swift
//  CoffeeShops
//
//  Created by Gopal Gurram on 1/8/23.
//

import Foundation

import UIKit.UIImage

protocol ImageLoader: AnyObject {
    func loadImage(from url: String, completion: @escaping (UIImage?) -> Void)
    func cancelLoadImage(url: String)
}

class ImageLoadManager: ImageLoader {
    let networkManager: NetworkManager
    let imageCacher: ImageCacheManager
    
    var inProgressRequests = [URL: URLSessionDataTask]()
    
    init(networkManager: NetworkManager, imageCacher: ImageCacheManager) {
        self.networkManager = networkManager
        self.imageCacher = imageCacher
    }
    
    convenience init() {
        self.init(networkManager: NetworkManager(), imageCacher: ImageCacheManager())
    }
    
    func loadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        guard let url = URL(string: url)
        else {
            return completion(nil)
        }
        
        let key = self.getKey(from: url)
        if let data = imageCacher.getData(for: key),
           let image = UIImage(data: data) {
            completion(image)
            return
        }
        
        guard inProgressRequests[url] == nil else { return }
        
        let workItem = networkManager.dataTask(with: url) { [weak self] (result: Result<Data, NetworkError>) in
            
            guard let self = self else { return }
            
            self.inProgressRequests[url] = nil
            DispatchQueue.main.async {
                if case .success(let data) = result,
                   let image = UIImage(data: data) {
                    self.imageCacher.cacheData(data, key)
                    return completion(image)
                }
                
                return completion(nil)
            }
        }
        
        inProgressRequests[url] = workItem
    }
    
    func cancelLoadImage(url: String) {
        guard let url = URL(string: url) else { return }
        
        let workItem = inProgressRequests[url]
        workItem?.cancel()
        inProgressRequests[url] = nil
    }
    
    private func getKey(from url: URL) -> String {
        let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        return components?.path.split(separator: "/").joined(separator: "") ?? "coffee"
    }
}
