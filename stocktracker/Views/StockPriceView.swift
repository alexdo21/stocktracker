//
//  StockPriceView.swift
//  stocktracker
//
//  Created by Alex Do on 3/2/22.
//

import UIKit

import UIKit

class StockPriceView: UIView {
    let price: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
        
    let priceChange: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.backgroundColor = .white
        self.addSubview(price)
        self.addSubview(priceChange)
        
        price.anchor(top: self.topAnchor, left: nil, bottom: nil, right: self.rightAnchor)
        priceChange.anchor(top: price.bottomAnchor, left: nil, bottom: self.bottomAnchor, right: self.rightAnchor)
    }

}
