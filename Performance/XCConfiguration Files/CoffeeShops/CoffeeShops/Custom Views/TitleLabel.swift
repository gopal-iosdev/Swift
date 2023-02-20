//
//  TitleLabel.swift
//  CoffeeShops
//
//  Created by Gopal Gurram on 1/7/23.
//

import UIKit.UILabel

class TitleLabel: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configure()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    convenience init(textAlignment: NSTextAlignment, fontSize: CGFloat) {
        self.init(frame: .zero)
        
        self.textAlignment = textAlignment
        self.font = UIFont.systemFont(ofSize: fontSize)
    }
    
    private func configure() {
        textColor = .label
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.9
        lineBreakMode = .byTruncatingTail
        translatesAutoresizingMaskIntoConstraints = false
    }
}
