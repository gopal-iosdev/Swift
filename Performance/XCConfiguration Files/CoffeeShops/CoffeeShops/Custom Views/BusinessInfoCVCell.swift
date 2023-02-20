//
//  BusinessInfoCVCell.swift
//  CoffeeShops
//
//  Created by Gopal Gurram on 1/8/23.
//

import UIKit

protocol ReUsableIdentifier: AnyObject {
    static var reUsableID: String { get }
}

extension ReUsableIdentifier where Self: UICollectionViewCell {
    static var reUsableID: String { String(describing: Self.self) }
}

class BusinessInfoCVCell: UICollectionViewCell, ReUsableIdentifier {
    var prepareToReuse: (() -> Void)?
    
    private let padding: CGFloat = 8
    
    lazy var avatarImageView: BusinessAvatarImageView = {
        return BusinessAvatarImageView(frame: .zero)
    }()
    
    lazy var nameLabel: TitleLabel = {
        return TitleLabel(textAlignment: .left, fontSize: 14)
    }()
    
    lazy var reviewLabel: TitleLabel = {
        return TitleLabel(textAlignment: .right, fontSize: 14)
    }()
    
    lazy var addressLabel: SecondaryTitleLabel = {
        return SecondaryTitleLabel(textAlignment: .left, fontSize: 10)
    }()
    
    lazy var priceLabel: TitleLabel = {
        return TitleLabel(textAlignment: .right, fontSize: 10)
    }()
    
    private lazy var avatarImageViewConstraints: [NSLayoutConstraint] = {
        [avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: padding),
         avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
         avatarImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
         avatarImageView.heightAnchor.constraint(equalTo: avatarImageView.widthAnchor)]
    }()
    
    private lazy var nameLabelConstraints: [NSLayoutConstraint] = {
        [nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 6),
         nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
         nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
         nameLabel.heightAnchor.constraint(equalToConstant: 20)]
    }()
    
    private lazy var reviewLabelConstraints: [NSLayoutConstraint] = {
        [reviewLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 6),
         reviewLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
         reviewLabel.centerXAnchor.constraint(equalTo: nameLabel.centerXAnchor),
         reviewLabel.heightAnchor.constraint(equalToConstant: 20)]
    }()
    
    private lazy var addressLabelConstraints: [NSLayoutConstraint] = {
        [addressLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
         addressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
         addressLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
         addressLabel.heightAnchor.constraint(equalToConstant: 16)]
    }()
    
    private lazy var priceLabelConstraints: [NSLayoutConstraint] = {
        [priceLabel.topAnchor.constraint(equalTo: reviewLabel.bottomAnchor, constant: 2),
         priceLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
         priceLabel.heightAnchor.constraint(equalToConstant: 16)]
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 10
        
        contentView.addSubViews(avatarImageView, nameLabel, reviewLabel, addressLabel, priceLabel)
        
        NSLayoutConstraint.activateList(avatarImageViewConstraints, nameLabelConstraints, reviewLabelConstraints, addressLabelConstraints, priceLabelConstraints)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        prepareToReuse?()
        reset()
    }
    
    private func reset() {
        avatarImageView.image = ImageAssets.coffeePlaceHolder.image
        priceLabel.text = ""
        nameLabel.text = ""
        addressLabel.text = ""
    }
    
}
