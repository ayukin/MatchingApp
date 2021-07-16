//
//  RegisterViewModel.swift
//  MatchingApp
//
//  Created by 720.nishioka on 2021/07/16.
//

import Foundation
import RxSwift
import RxCocoa

// RegisterViewModelから見た入力
protocol RegisterViewModelInputs {
    var nameTextInput: AnyObserver<String> { get }
    var emailTextInput: AnyObserver<String> { get }
    var passwordTextInput: AnyObserver<String> { get }
}

// RegisterViewModelから見た出力
protocol RegisterViewModelOutputs {
    var nameTextOutput: PublishSubject<String> { get }
    var emailTextOutput: PublishSubject<String> { get }
    var passwordTextOutput: PublishSubject<String> { get }
}

class RegisterViewModel: RegisterViewModelInputs, RegisterViewModelOutputs {
    
    private let disposeBag = DisposeBag()
    
    // MARK: observable
    // ViewControllerへの出力
    var nameTextOutput = PublishSubject<String>()
    var emailTextOutput = PublishSubject<String>()
    var passwordTextOutput = PublishSubject<String>()
    
    var validRegisterSubject = BehaviorSubject<Bool>(value: false)
    
    // MARK: observer
    // ViewControllerからの入力
    var nameTextInput: AnyObserver<String> {
        nameTextOutput.asObserver()
    }
    
    var emailTextInput: AnyObserver<String> {
        emailTextOutput.asObserver()
    }
    
    var passwordTextInput: AnyObserver<String> {
        passwordTextOutput.asObserver()
    }
    
    var validRegisterDriver: Driver<Bool> = Driver.never()
    
    
    init() {
        
        validRegisterDriver = validRegisterSubject
            .asDriver(onErrorDriveWith: Driver.empty())
        
        let nameValid = nameTextOutput
            .asObserver()
            .map { text -> Bool in
                return text.count >= 5
            }
        
        let emailValid = emailTextOutput
            .asObserver()
            .map { text -> Bool in
                return text.count >= 5
            }
        
        let passwordValid = passwordTextOutput
            .asObserver()
            .map { text -> Bool in
                return text.count >= 5
            }
        // 全部の条件がOKであればtrueを流す処理
        Observable.combineLatest(nameValid, emailValid, passwordValid) { $0 && $1 && $2 }
            .subscribe { validAll in
                self.validRegisterSubject.onNext(validAll)
            }
            .disposed(by: disposeBag)
    }
}
