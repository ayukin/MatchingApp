//
//  Firebase_Extension.swift
//  MatchingApp
//
//  Created by 720.nishioka on 2021/07/16.
//

import Firebase

// MARK: - Auth
extension Auth {
    static func createUserToFireAuth(email: String?, password: String?, name: String?, completion: @escaping (Bool) -> Void) {
        
        guard let email = email else { return }
        guard let password = password else { return }
        
        Auth.auth().createUser(withEmail: email, password: password) { (auth, error) in
            if let error = error {
                print("auth情報の保存失敗", error)
                return
            }
            guard let uid = auth?.user.uid else { return }
            Firestore.seuUserDataToFiresotre(email: email, uid: uid, name: name) { success in
                completion(true)
            }
        }
    }

}

// MARK: - Firestore
extension Firestore {
    static func seuUserDataToFiresotre(email: String, uid: String, name: String?, completion: @escaping (Bool) -> () ) {
        
        guard let name = name else { return }
        
        let document = [
            "name": name,
            "email": email,
            "createdAt": Timestamp()
        ] as [String : Any]
        
        Firestore.firestore().collection("users").document(uid).setData(document) { error in
            if let error = error {
                print("ユーザー情報をfirestoreに保存失敗", error)
            }
            print("ユーザー情報をfirestoreに保存成功")
            completion(true)
        }
    }

}
