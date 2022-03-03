//
//  StockInfoContainer.swift
//  stocktracker
//
//  Created by Alex Do on 3/2/22.
//

import UIKit

class StockInfoContainerView: UIView {    
    let open: InfoCell = {
        let cell = InfoCell()
        cell.title.text = "Open"
        return cell
    }()
    let high: InfoCell = {
        let cell = InfoCell()
        cell.title.text = "High"
        return cell
    }()
    let low: InfoCell = {
        let cell = InfoCell()
        cell.title.text = "Low"
        return cell
    }()
    let volume: InfoCell = {
        let cell = InfoCell()
        cell.title.text = "Volume"
        return cell
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
        self.addSubview(self.open)
        self.addSubview(high)
        self.addSubview(low)
        self.addSubview(volume)
        
        self.open.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: high.leftAnchor, padding: .init(top: 0, left: 18, bottom: 0, right: 25), size: .init(width: 52, height: 30))
        high.anchor(top: self.topAnchor, left: self.open.rightAnchor, bottom: self.bottomAnchor, right: low.leftAnchor, padding: .init(top: 0, left: 25, bottom: 0, right: 25), size: .init(width: 52, height: 30))
        low.anchor(top: self.topAnchor, left: high.rightAnchor, bottom: self.bottomAnchor, right: volume.leftAnchor, padding: .init(top: 0, left: 25, bottom: 0, right: 25), size: .init(width: 52, height: 30))
        volume.anchor(top: self.topAnchor, left: low.rightAnchor, bottom: self.bottomAnchor, right: nil, padding: .init(top: 0, left: 25, bottom: 0, right: 0), size: .init(width: 52, height: 30))
    }
}
