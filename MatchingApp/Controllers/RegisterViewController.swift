//
//  RegisterViewController.swift
//  MatchingApp
//
//  Created by 720.nishioka on 2021/07/13.
//

import UIKit

class RegisterViewController: UIViewController {
    
    private let nameTextField = RegisterTextField(placeHolder: "名前")
    private let emailTextField = RegisterTextField(placeHolder: "email")
    private let passwordTextField = RegisterTextField(placeHolder: "password")
        
    let registerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("登録", for: .normal)
        button.backgroundColor = .red
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let baseStackView = UIStackView(arrangedSubviews: [nameTextField, emailTextField, passwordTextField, registerButton])
        baseStackView.axis = .vertical
        baseStackView.distribution = .fillEqually
        baseStackView.spacing = 20
        
        self.view.addSubview(baseStackView)
        
        // fillEquallyを設定しているため、全ての高さが準拠する。baseStackViewの高さ指定いらない。
        nameTextField.anchor(height: 45)
        
        baseStackView.anchor(left: view.leftAnchor, right: view.rightAnchor, centerY: view.centerYAnchor, leftPadding: 20, rightPadding: 20)
        
    }
}
