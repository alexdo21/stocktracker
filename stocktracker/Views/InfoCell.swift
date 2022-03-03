//
//  InfoCell.swift
//  stocktracker
//
//  Created by Alex Do on 3/2/22.
//

import UIKit

class InfoCell: UIView {
    let title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .light)
        label.textAlignment = .center
        return label
    }()
    
    let value: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10, weight: .bold)
        label.textAlignment = .center
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
        self.addSubview(title)
        self.addSubview(value)
        
        title.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: self.rightAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        value.anchor(top: title.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, padding: .init(top: 0, left: 0, bottom: 0, right: 0))
    }
}
