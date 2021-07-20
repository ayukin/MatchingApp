//
//  ViewController.swift
//  MatchingApp
//
//  Created by 720.nishioka on 2021/07/04.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class HomeViewController: UIViewController {
    
    private var user: User?
    
    let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("ログアウト", for: .normal)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
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
        
    }
    
    private func setupLayout() {
        view.backgroundColor = UIColor.white
        
        let topControlView = TopControlView()
        let cardView = CardView()
        let bottomControlView = BottomControlView()
        
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
}

