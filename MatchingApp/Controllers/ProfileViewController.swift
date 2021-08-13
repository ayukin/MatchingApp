//
//  ProfileViewController.swift
//  MatchingApp
//
//  Created by 720.nishioka on 2021/08/01.
//

import UIKit
import RxSwift
import FirebaseFirestore
import FirebaseStorage

class ProfileViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    var user: User?
    private let cellId = "cellId"
    private var hasChangedImage = false
    
    private var name = ""
    private var age = ""
    private var email = ""
    private var residence = ""
    private var hobby = ""
    private var introduction = ""

    // MARK: UIViews
    let saveButton = UIButton(type: .system).createProfileTopButton(text: "保存")
    let logoutButton = UIButton(type: .system).createProfileTopButton(text: "ログアウト")
    let profileImageView = ProfileImageView()
    let nameLabel = ProfileLabel()
    let profileEditButton = UIButton(type: .system).createProfileEditButton()

    lazy var infoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        // 中のviewを元に自動で大きさが変わってくれる
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        collectionView.register(InfoCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupBindings()
    }
    
    private func setupBindings() {
        saveButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                guard let self = self else { return }
                
                let dic = [
                    "name": self.name,
                    "age": self.age,
                    "email": self.email,
                    "residence": self.residence,
                    "hobby": self.hobby,
                    "introduction": self.introduction,
                ]
                
                if self.hasChangedImage {
                    // 画像を保存する処理
                    guard let image = self.profileImageView.image else { return }
                    Storage.addProfileImageToStorage(image: image, dic: dic) {
                        //
                    }
                }
                
                Firestore.updateUserInfo(dic: dic) {
                    print("更新完了")
                }
                
            }
            .disposed(by: disposeBag)
        
        profileEditButton.rx.tap
            .asDriver()
            .drive { [weak self] _ in
                let pickerView = UIImagePickerController()
                pickerView.delegate = self
                self?.present(pickerView, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
        
        
    }

    private func setupLayout() {

        view.backgroundColor = .white
        nameLabel.text = "test test"
        
        // Viewの配置を設定
        view.addSubview(saveButton)
        view.addSubview(logoutButton)
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(profileEditButton)
        view.addSubview(infoCollectionView)

        saveButton.anchor(top: view.topAnchor, left: view.leftAnchor, topPadding: 20, leftPadding: 15)
        logoutButton.anchor(top: view.topAnchor, right: view.rightAnchor, topPadding: 20, rightPadding: 15)
        profileImageView.anchor(top: view.topAnchor, centerX: view.centerXAnchor, width: 180, height: 180, topPadding: 60)
        nameLabel.anchor(top: profileImageView.bottomAnchor, centerX: view.centerXAnchor, topPadding: 20)
        profileEditButton.anchor(top: profileImageView.topAnchor, right: profileImageView.rightAnchor, width: 60, height: 60)
        infoCollectionView.anchor(top: nameLabel.bottomAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, topPadding: 20)
        
        // ユーザー情報を反映
        nameLabel.text = user?.name

    }

}

// MARK: - UIImagePickerControllerDelegate, UIImagePickerControllerDelegate
extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            profileImageView.image = image.withRenderingMode(.alwaysOriginal)
        }
        
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 90
        profileImageView.layer.masksToBounds = true
        
        hasChangedImage = true
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegate
extension ProfileViewController: UICollectionViewDelegate {

}

// MARK: - UICollectionViewDataSource
extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = infoCollectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! InfoCollectionViewCell
        cell.user = self.user
        setupCellBindings(cell: cell)
        return cell
    }
    
    private func setupCellBindings(cell: InfoCollectionViewCell) {
        
        cell.nameTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.name = text ?? ""
            }
            .disposed(by: disposeBag)
        
        cell.ageTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.age = text ?? ""
            }
            .disposed(by: disposeBag)
        
        cell.emailTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.email = text ?? ""
            }
            .disposed(by: disposeBag)
        
        cell.residenceTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.residence = text ?? ""
            }
            .disposed(by: disposeBag)
        
        cell.hobbyTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.hobby = text ?? ""
            }
            .disposed(by: disposeBag)
        
        cell.introductionTextField.rx.text
            .asDriver()
            .drive { [weak self] text in
                self?.introduction = text ?? ""
            }
            .disposed(by: disposeBag)
    }

}
