//
//  ImageTableViewCell.swift
//  MainThread
//
//  Created by Gopal Gurram on 1/28/23.
//

import UIKit

final class ImageTableViewCell: UITableViewCell {

    // MARK: - Static Properties
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: - Properties
    
    @IBOutlet private var titleLabel: UILabel!
    
    // MARK: -
    
    @IBOutlet private var thumbnailImageView: UIImageView!

    // MARK: - Public API
    
    func configure(with title: String, url: URL?) {
        // Configure Title Label
        titleLabel.text = title
        
        // Load Data
        
        // MARK: - Problem: Blocking Main Queue
        
        if let url = url, let data = try? Data(contentsOf: url) {
            // Configure Thumbnail Image View
            thumbnailImageView.image = UIImage(data: data)
        }
        
        // MARK: - Solution: Unblocking Main Queue
        
//        guard let url else { return }
//
//        DispatchQueue.global(qos: .background).async {
//            guard let data = try? Data(contentsOf: url),
//                  let image = UIImage(data: data)
//            else { return }
//
//            // Configure Thumbnail Image View
//            DispatchQueue.main.async {
//                self.thumbnailImageView.image = image
//            }
//        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Reset Thumnail Image View
        thumbnailImageView.image = nil
    }
    
}
