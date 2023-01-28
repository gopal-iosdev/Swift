//
//  ImageTableViewCell.swift
//  IncreaseAppPerformanceWithCaching
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
    
    private var dataTask: URLSessionDataTask?
    
    @IBOutlet private var titleLabel: UILabel!
    
    // MARK: -
    
    @IBOutlet private var thumbnailImageView: UIImageView!
    
    @IBOutlet private var activityIndicatorView: UIActivityIndicatorView!

    // MARK: - Public API
    
    func configure(with title: String, url: URL?, session: URLSession) {
        // Configure Title Label
        titleLabel.text = title
        
        // Load Data
        
        // MARK: - Problem: Redownloads image everytime a cell is reloaded.
        
        guard let url else { return }
        
        activityIndicatorView.startAnimating()
        
        let dataTask = session.dataTask(with: URLRequest(url: url)) { [weak self] (data, _, _) in
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data)?.resizedImage(with: CGSize(width: 200.0, height: 200.0))
            else { return }
            
            // Configure Thumbnail Image View
            DispatchQueue.main.async {
                self?.thumbnailImageView.image = image
                self?.activityIndicatorView.stopAnimating()
            }
        }
        
        dataTask.resume()
        
        self.dataTask = dataTask
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        dataTask?.cancel()
        dataTask = nil
        
        // Reset Thumnail Image View
        thumbnailImageView.image = nil
    }
    
}
