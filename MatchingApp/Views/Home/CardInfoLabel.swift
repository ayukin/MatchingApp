//
//  CardInfoLabel.swift
//  MatchingApp
//
//  Created by 720.nishioka on 2021/07/10.
//

import UIKit

class CardInfoLabel: UILabel {
    
    
    // noprとgoodのラベル
    init(text: String, textColor: UIColor) {
        super.init(frame: .zero)
        
        font = .boldSystemFont(ofSize: 45)
        self.textColor = textColor
        self.text = text
        
        layer.borderWidth = 3
        layer.borderColor = textColor.cgColor
        layer.cornerRadius = 10
        textAlignment = .center
        alpha = 0
        
    }
    
    // その他のtextColorが白のラベル
    init(text: String, font: UIFont) {
        super.init(frame: .zero)
        
        self.font = font
        textColor = .white
        self.text = text
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
