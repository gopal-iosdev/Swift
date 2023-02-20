//
//  ImageCacheManager.swift
//  CoffeeShops
//
//  Created by Gopal Gurram on 1/7/23.
//

import Foundation

protocol DataCacher {
    func cacheData(_ data: Data, _ key: String)
    func getData(for key: String) -> Data?
}

class ImageCacheManager: DataCacher {
    func cacheData(_ data: Data, _ key: String) {
        let path = FileManager.imageCachePath(for: key)
        do {
            try data.write(to: path, options: [.atomic])
        } catch {
            print(error)
        }
    }
    
    func getData(for key: String) -> Data? {
        guard FileManager.imageExists(with: key)
        else { return nil }
        
        do {
            let data = try Data(contentsOf: FileManager.imageCachePath(for: key))
            return data
        } catch {
            return nil
        }
    }
}

extension FileManager {
    static func imageCachePath(for key: String) -> URL {
        return cacheDirectoryPath.appendingPathComponent(key)
    }
    
    static var cacheDirectoryPath: URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
    }
    
    static func imageExists(with key: String) -> Bool {
        let path = imageCachePath(for: key)
        return FileManager.default.fileExists(atPath: path.relativePath)
    }
}

