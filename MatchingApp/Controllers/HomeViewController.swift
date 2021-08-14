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
    private var isCardAnimating = false
    
    // 自分以外のユーザー情報
    private var users = [User]()
    
    let topControlView = TopControlView()
    let cardView = UIView()
    let bottomControlView = BottomControlView()
    
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
        
        self.users = []
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
        
        let stackView = UIStackView(arrangedSubviews: [topControlView, cardView, bottomControlView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        
        self.view.addSubview(stackView)
                
        NSLayoutConstraint.activate([
            topControlView.heightAnchor.constraint(equalToConstant: 100),
            bottomControlView.heightAnchor.constraint(equalToConstant: 120),
            
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            stackView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
    }
    
    private func setupBindings() {
        topControlView.profileButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                let profile = ProfileViewController()
                profile.user = self?.user
                profile.presentationController?.delegate = self
                self?.present(profile, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        bottomControlView.reloadView.button?.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                self?.fetchUsers()
            }
            .disposed(by: disposeBag)
        
        bottomControlView.closeView.button?.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                guard let self = self else { return }
                
                if !self.isCardAnimating {
                    self.isCardAnimating = true
                    self.cardView.subviews.last?.removeCardViewAnimation(x: -600, completion: {
                        self.isCardAnimating = false
                    })
                }
            }
            .disposed(by: disposeBag)
        
        bottomControlView.heartView.button?.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                guard let self = self else { return }
                
                if !self.isCardAnimating {
                    self.isCardAnimating = true
                    self.cardView.subviews.last?.removeCardViewAnimation(x: 600, completion: {
                        self.isCardAnimating = false
                    })
                }
            }
            .disposed(by: disposeBag)
        
    }
    
}

// MARK: - UIAdaptivePresentationControllerDelegate
extension HomeViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        if Auth.auth().currentUser == nil {
            self.user = nil
            self.users = []
            
            let registerVC = RegisterViewController()
            let nav = UINavigationController(rootViewController: registerVC)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
}

