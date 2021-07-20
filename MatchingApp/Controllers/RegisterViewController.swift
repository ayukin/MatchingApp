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
import FirebaseFirestore
import PKHUD

class RegisterViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = RegisterViewModel()
    
    private let titleLabel = RegisterTitleLabel(text: "Tinder")
    private let nameTextField = RegisterTextField(placeHolder: "名前")
    private let emailTextField = RegisterTextField(placeHolder: "email")
    private let passwordTextField = RegisterTextField(placeHolder: "password")
    private let registerButton = RegisterButton(text: "登録")
    private let alreadyHaveAccountButton = UIButton(type: .system).createAboutAccountButton(text: "すでにアカウントをお持ちの場合はこちら")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setupGradientLayer()をsetupLayout()より先に呼ぶ
        setupGradientLayer()
        setupLayout()
        setupBindings()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
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
        self.view.addSubview(alreadyHaveAccountButton)
        
        // fillEquallyを設定しているため、全ての高さが準拠する。baseStackViewの高さ指定いらない。
        nameTextField.anchor(height: 45)
        
        baseStackView.anchor(left: view.leftAnchor, right: view.rightAnchor, centerY: view.centerYAnchor, leftPadding: 20, rightPadding: 20)
        titleLabel.anchor(bottom: baseStackView.topAnchor, centerX: view.centerXAnchor, bottomPadding: 20)
        alreadyHaveAccountButton.anchor(top: baseStackView.bottomAnchor, centerX: view.centerXAnchor, topPadding: 20)
    }
    
    private func setupBindings() {
        // textFieldのbinding
        nameTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.viewModel.nameTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        emailTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.viewModel.emailTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.viewModel.passwordTextInput.onNext(text ?? "")
            }
            .disposed(by: disposeBag)
        
        // buttonのbinding
        registerButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                // 登録処理
                self?.createUser()
            }
            .disposed(by: disposeBag)
        
        alreadyHaveAccountButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                // 遷移処理
                let loginVC = LoginViewController()
                self?.navigationController?.pushViewController(loginVC, animated: true)
            }
            .disposed(by: disposeBag)
        
        // viewModelのbinding
        viewModel.validRegisterDriver
            .drive { validAll in
                self.registerButton.isEnabled = validAll
                self.registerButton.backgroundColor = validAll ? .rgb(red: 227, green: 48, blue: 78) : .init(white: 0.7, alpha: 1)
            }
            .disposed(by: disposeBag)
    }
    
    private func createUser() {
        let email = emailTextField.text
        let password = passwordTextField.text
        let name = nameTextField.text
        
        HUD.show(.progress)
        
        Auth.createUserToFireAuth(email: email, password: password, name: name) { success in
            HUD.hide()
            if success {
                print("処理完了")
                self.dismiss(animated: true, completion: nil)
            } else {
                
            }
        }
    }
    
}
