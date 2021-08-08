//
//  UIView_Extension.swift
//  MatchingApp
//
//  Created by 720.nishioka on 2021/07/05.
//

import UIKit

extension UIView {
    
    func anchor(
        top: NSLayoutYAxisAnchor? = nil,
        bottom: NSLayoutYAxisAnchor? = nil,
        left: NSLayoutXAxisAnchor? = nil,
        right: NSLayoutXAxisAnchor? = nil,
        centerY: NSLayoutYAxisAnchor? = nil,
        centerX: NSLayoutXAxisAnchor? = nil,
        width: CGFloat? = nil,
        height: CGFloat? = nil,
        topPadding: CGFloat = 0,
        bottomPadding: CGFloat = 0,
        leftPadding: CGFloat = 0,
        rightPadding: CGFloat = 0
    ) {
        
        self.translatesAutoresizingMaskIntoConstraints = false
        // 上端の制約
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: topPadding).isActive = true
        }
        // 下端の制約
        if let bottom = bottom {
            self.bottomAnchor.constraint(equalTo: bottom, constant: -bottomPadding).isActive = true
        }
        // 左端の制約
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: leftPadding).isActive = true
        }
        // 右端の制約
        if let right = right {
            self.rightAnchor.constraint(equalTo: right, constant: -rightPadding).isActive = true
        }
        // 垂直方向の制約
        if let centerY = centerY {
            self.centerYAnchor.constraint(equalTo: centerY).isActive = true
        }
        // 水平方向の制約
        if let centerX = centerX {
            self.centerXAnchor.constraint(equalTo: centerX).isActive = true
        }
        // 幅の制約
        if let width = width {
            self.widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        // 高さの制約
        if let height = height {
            self.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
        
    }
    
}

// MARK: Animations
extension UIView {
    
    func removeCardViewAnimation(x: CGFloat) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.7, options: []) {
            let degree: CGFloat = x / 40
            let angle = degree * .pi / 180
            let rotateTranslation = CGAffineTransform(rotationAngle: angle)
            self.transform = rotateTranslation.translatedBy(x: x, y: 100)
            self.layoutIfNeeded()
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}
