//
//  ViewController.swift
//  MatchingApp
//
//  Created by 720.nishioka on 2021/07/04.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import PKHUD
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    private var user: User?
    // 自分以外のユーザー情報
    private var users = [User]()
    
    let topControlView = TopControlView()
    let cardView = UIView()
    let bottomControlView = BottomControlView()
    
    let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("ログアウト", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
        setupBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if Auth.auth().currentUser?.uid == nil {
            let registerVC = RegisterViewController()
            let nav = UINavigationController(rootViewController: registerVC)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firestore.fetchUserFromFirestore(uid: uid) { (user) in
            if let user = user {
                self.user = user
            }
        }
        
        fetchUsers()
        
    }
    
    private func fetchUsers() {
        HUD.show(.progress)
        Firestore.fetchUsersFromFirestore { (users) in
            HUD.hide()
            self.users = users
            
            self.users.forEach { (user) in
                let card = CardView(user: user)
                self.cardView.addSubview(card)
                card.anchor(top: self.cardView.topAnchor, bottom: self.cardView.bottomAnchor, left: self.cardView.leftAnchor, right: self.cardView.rightAnchor)
            }
            
            
            print("自分以外のユーザー情報取得に成功")
        }
    }
    
    
    private func setupLayout() {
        view.backgroundColor = UIColor.white
        
//        let topControlView = TopControlView()
//        let cardView = CardView()
//        let bottomControlView = BottomControlView()
        
        let stackView = UIStackView(arrangedSubviews: [topControlView, cardView, bottomControlView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        self.view.addSubview(stackView)
        self.view.addSubview(logoutButton)
                
        NSLayoutConstraint.activate([
            topControlView.heightAnchor.constraint(equalToConstant: 100),
            bottomControlView.heightAnchor.constraint(equalToConstant: 120),
            
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        logoutButton.anchor(bottom: view.bottomAnchor, left: view.leftAnchor, bottomPadding: 10, leftPadding: 10)
        
        logoutButton.addTarget(self, action: #selector(tappedLogoutButton), for: .touchUpInside)
    }
    
    @objc private func tappedLogoutButton() {
        
        do {
            try Auth.auth().signOut()
            let registerVC = RegisterViewController()
            let nav = UINavigationController(rootViewController: registerVC)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        } catch {
            print("ログアウト失敗：", error)
            
        }
        
    }
    
    private func setupBindings() {
        topControlView.profileButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                let profile = ProfileViewController()
                profile.user = self?.user
                self?.present(profile, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }
    
}

