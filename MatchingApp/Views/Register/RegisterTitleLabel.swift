//
//  RegisterTitleLabel.swift
//  MatchingApp
//
//  Created by 720.nishioka on 2021/07/16.
//

import UIKit

class RegisterTitleLabel: UILabel {
    
    init() {
        super.init(frame: .zero)
        
        self.text = "Tinder"
        self.font = .boldSystemFont(ofSize: 80)
        self.textColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

