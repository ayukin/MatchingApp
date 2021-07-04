//
//  TopControlView.swift
//  MatchingApp
//
//  Created by 720.nishioka on 2021/07/04.
//

import UIKit
import RxSwift
import RxCocoa

class TopControlView: UIView {
    
    private let disposeBag = DisposeBag()
    
    let tinderButton = createTopButton(imageName: "tinder_selected", unselectedImageName: "tinder_unselected")
    let goodButton = createTopButton(imageName: "good_selected", unselectedImageName: "good_unselected")
    let commentButton = createTopButton(imageName: "comment_selected", unselectedImageName: "comment_unselected")
    let profileButton = createTopButton(imageName: "profile_selected", unselectedImageName: "profile_unselected")
    
    static private func createTopButton(imageName: String, unselectedImageName: String) -> UIButton {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: imageName), for: .selected)
        button.setImage(UIImage(named: unselectedImageName), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupBindings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let baseStackView = UIStackView(arrangedSubviews: [tinderButton, goodButton, commentButton, profileButton])
        baseStackView.axis = .horizontal
        baseStackView.distribution = .fillEqually
        baseStackView.spacing = 40
        baseStackView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(baseStackView)
        
        NSLayoutConstraint.activate([
            baseStackView.topAnchor.constraint(equalTo: topAnchor),
            baseStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            baseStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 40),
            baseStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -40),
        ])
        
        tinderButton.isSelected = true
    }
    
    private func setupBindings() {
        tinderButton.rx.tap
            .subscribe { _ in
                self.handleSelectedButton(selectedButton: self.tinderButton)
            }
            .disposed(by: disposeBag)
        goodButton.rx.tap
            .subscribe { _ in
                self.handleSelectedButton(selectedButton: self.goodButton)
            }
            .disposed(by: disposeBag)
        commentButton.rx.tap
            .subscribe { _ in
                self.handleSelectedButton(selectedButton: self.commentButton)
            }
            .disposed(by: disposeBag)
        profileButton.rx.tap
            .subscribe { _ in
                self.handleSelectedButton(selectedButton: self.profileButton)
            }
            .disposed(by: disposeBag)
    }
    
    private func handleSelectedButton(selectedButton: UIButton) {
        let buttons = [tinderButton, goodButton, commentButton, profileButton]
        buttons.forEach { button in
            if button == selectedButton {
                button.isSelected = true
            } else {
                button.isSelected = false
            }
        }
    }
    
}
