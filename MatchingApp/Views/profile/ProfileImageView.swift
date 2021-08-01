//
//  ProfileImageView.swift
//  MatchingApp
//
//  Created by 720.nishioka on 2021/08/01.
//

import UIKit

class ProfileImageView: UIImageView {
    
    init() {
        super.init(frame: .zero)
        
        self.image = UIImage(named: "no_image")
        self.contentMode = .scaleAspectFill
        self.layer.cornerRadius = 90
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

