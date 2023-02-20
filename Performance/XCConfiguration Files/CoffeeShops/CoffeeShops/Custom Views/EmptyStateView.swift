//
//  EmptyStateView.swift
//  CoffeeShops
//
//  Created by Gopal Gurram on 1/7/23.
//

import UIKit

class EmptyStateView: UIView {
    
    private lazy var messageLabel: TitleLabel = {
        let messageLabel = TitleLabel(textAlignment: .center, fontSize: 34.0)
        messageLabel.numberOfLines = 0
        messageLabel.textColor = .secondaryLabel
        messageLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        
        return messageLabel
    }()
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.image = ImageAssets.envoyLogo.image
        
        return imageView
    }()
    
    private lazy var messageLabelConstraints: [NSLayoutConstraint] = {
        [messageLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 40),
         messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
         messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
         messageLabel.heightAnchor.constraint(equalToConstant: 80)]
    }()
    
    private lazy var logoImageViewConstraints: [NSLayoutConstraint] = {
        [logoImageView.widthAnchor.constraint(equalToConstant: 225),
         logoImageView.heightAnchor.constraint(equalToConstant: 225),
         logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
         logoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40)]
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(message: String) {
        self.init(frame: .zero)
        
        messageLabel.text = message
    }
    
    private func configure() {
        addSubViews(messageLabel, logoImageView)
        
        NSLayoutConstraint.activateList(messageLabelConstraints, logoImageViewConstraints)
    }
}
