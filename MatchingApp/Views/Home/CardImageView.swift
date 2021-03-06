//
//  CardImageView.swift
//  MatchingApp
//
//  Created by 720.nishioka on 2021/07/10.
//

import UIKit

class CardImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.gray
        layer.cornerRadius = 10
        contentMode = .scaleAspectFill
        clipsToBounds = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
