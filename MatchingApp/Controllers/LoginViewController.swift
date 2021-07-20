//
//  LoginViewController.swift
//  MatchingApp
//
//  Created by 720.nishioka on 2021/07/19.
//

import UIKit
import RxSwift
import RxCocoa
import FirebaseAuth
import PKHUD

class LoginViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private let titleLabel = RegisterTitleLabel(text: "LOGIN")
    private let emailTextField = RegisterTextField(placeHolder: "email")
    private let passwordTextField = RegisterTextField(placeHolder: "password")
    private let loginButton = RegisterButton(text: "ログイン")
    private let dontHaveAccountButton = UIButton(type: .system).createAboutAccountButton(text: "アカウントをお持ちでない場合はこちら")
    
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
        
        let baseStackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        baseStackView.axis = .vertical
        baseStackView.distribution = .fillEqually
        baseStackView.spacing = 20
        
        self.view.addSubview(baseStackView)
        self.view.addSubview(titleLabel)
        self.view.addSubview(dontHaveAccountButton)
        
        // fillEquallyを設定しているため、全ての高さが準拠する。baseStackViewの高さ指定いらない。
        emailTextField.anchor(height: 45)
        
        baseStackView.anchor(left: view.leftAnchor, right: view.rightAnchor, centerY: view.centerYAnchor, leftPadding: 20, rightPadding: 20)
        titleLabel.anchor(bottom: baseStackView.topAnchor, centerX: view.centerXAnchor, bottomPadding: 20)
        dontHaveAccountButton.anchor(top: baseStackView.bottomAnchor, centerX: view.centerXAnchor, topPadding: 20)
    }
    
    private func setupBindings() {
        // textFieldのbinding
        emailTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
//                self?.viewModel.emailTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
//                self?.viewModel.passwordTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        // buttonのbinding
        loginButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                // 登録処理
                self?.login()
            }
            .disposed(by: disposeBag)
        
        dontHaveAccountButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                // 遷移処理
                self?.navigationController?.popViewController(animated: true)
            }
            .disposed(by: disposeBag)
        
        // viewModelのbinding
//        viewModel.validRegisterDriver
//            .drive { validAll in
//                self.registerButton.isEnabled = validAll
//                self.registerButton.backgroundColor = validAll ? .rgb(red: 227, green: 48, blue: 78) : .init(white: 0.7, alpha: 1)
//            }
//            .disposed(by: disposeBag)
    }
    
    private func login() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        HUD.show(.progress)
        Auth.loginWithFireAuth(email: email, password: password) { (success) in
            HUD.hide()
            if success {
                print("ログイン成功")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
