//
//  RegisterViewModel.swift
//  MatchingApp
//
//  Created by 720.nishioka on 2021/07/16.
//

import Foundation
import RxSwift

class RegisterViewModel {
    
    private let disposeBag = DisposeBag()
    
    // MARK: observable
    // ViewControllerへの出力
    var nameTextOutput = PublishSubject<String>()
    var emailTextOutput = PublishSubject<String>()
    var passwordTextOutput = PublishSubject<String>()
    
    // MARK: observer
    // ViewControllerからの入力
    var nemeTextInput: AnyObserver<String> {
        nameTextOutput.asObserver()
    }
    
    var emailTextInput: AnyObserver<String> {
        emailTextOutput.asObserver()
    }
    
    var passwordTextInput: AnyObserver<String> {
        passwordTextOutput.asObserver()
    }
    
    
    init() {
        nameTextOutput
            .asObserver()
            .subscribe { text in
                print("name:", text)
            }
            .disposed(by: disposeBag)
        
        emailTextOutput
            .asObserver()
            .subscribe { text in
                print("email:", text)
            }
            .disposed(by: disposeBag)
        
        passwordTextOutput
            .asObserver()
            .subscribe { text in
                print("password:", text)
            }
            .disposed(by: disposeBag)
    }
}
