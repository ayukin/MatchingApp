//
//  RegisterViewController.swift
//  MatchingApp
//
//  Created by 720.nishioka on 2021/07/13.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let titleLabel = RegisterTitleLabel()
    private let nameTextField = RegisterTextField(placeHolder: "名前")
    private let emailTextField = RegisterTextField(placeHolder: "email")
    private let passwordTextField = RegisterTextField(placeHolder: "password")
    private let registerButton = RegisterButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setupGradientLayer()をsetupLayout()より先に呼ぶ
        setupGradientLayer()
        setupLayout()
        setupBindings()
        
    }
    
    private func setupGradientLayer() {
        let layer = CAGradientLayer()
        let startColor = UIColor.rgb(red: 227, green: 48, blue: 78).cgColor
        let endColor = UIColor.rgb(red: 245, green: 208, blue: 108).cgColor
        
        layer.colors = [startColor, endColor]
        layer.locations = [0.0, 1.3]
        layer.frame = view.bounds
        self.view.layer.addSublayer(layer)
    }
    
    private func setupLayout() {
        
        passwordTextField.isSecureTextEntry = true
        
        let baseStackView = UIStackView(arrangedSubviews: [nameTextField, emailTextField, passwordTextField, registerButton])
        baseStackView.axis = .vertical
        baseStackView.distribution = .fillEqually
        baseStackView.spacing = 20
        
        self.view.addSubview(baseStackView)
        self.view.addSubview(titleLabel)
        
        // fillEquallyを設定しているため、全ての高さが準拠する。baseStackViewの高さ指定いらない。
        nameTextField.anchor(height: 45)
        
        baseStackView.anchor(left: view.leftAnchor, right: view.rightAnchor, centerY: view.centerYAnchor, leftPadding: 20, rightPadding: 20)
        titleLabel.anchor(bottom: baseStackView.topAnchor, centerX: view.centerXAnchor, bottomPadding: 20)
    }
    
    private func setupBindings() {
        nameTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                // 内容
            }
            .disposed(by: disposeBag)
        
        emailTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                // 内容
            }
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                // 内容
            }
            .disposed(by: disposeBag)
        
        registerButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                // 登録処理
                self?.createUserToFireAuth()
            }
            .disposed(by: disposeBag)
    }
    
    private func createUserToFireAuth() {
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (auth, error) in
            if let error = error {
                print("auth情報の保存失敗", error)
                return
            }
            guard let uid = auth?.user.uid else { return }
            print("auth情報の保存成功", uid)
        }
    }
    
}
