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
    
    static func loginWithFireAuth(email: String, password: String, completion: @escaping (Bool) -> Void) {
        
        Auth.auth().signIn(withEmail: email, password: password) { (res, error) in
            if let error = error {
                print("ログイン失敗", error)
                completion(false)
                return
            }
            print("ログイン成功")
            completion(true)
        }
    }

}

// MARK: - Firestore
extension Firestore {
    static func seuUserDataToFiresotre(email: String, uid: String, name: String?, completion: @escaping (Bool) -> ()) {
        
        guard let name = name else { return }
        
        let document = [
            "name": name,
            "email": email,
            "createdAt": Timestamp()
        ] as [String : Any]
        
        Firestore.firestore().collection("users").document(uid).setData(document) { error in
            if let error = error {
                print("ユーザー情報をfirestoreに保存失敗", error)
                return
            }
            print("ユーザー情報をfirestoreに保存成功")
            completion(true)
        }
    }
    
    static func fetchUserFromFirestore(uid: String, completion: @escaping (User?) -> Void) {
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, error) in
            if let error = error {
                print("ユーザー情報の取得失敗", error)
                completion(nil)
                return
            }
            
            guard let dic = snapshot?.data() else { return }
            let user = User(dic: dic)
            completion(user)
        }
    }
    
    
    static func fetchUsersFromFirestore(completion: @escaping ([User]) -> Void) {
        Firestore.firestore().collection("users").getDocuments { (snapshots, error) in
            if let error = error {
                print("ユーザー情報の取得失敗", error)
                return
            }
//            var users = [User]()
//            snapshots?.documents.forEach({ (snapshot) in
//                let dic = snapshot.data()
//                let user = User(dic: dic)
//                users.append(user)
//            })
            
            let users = snapshots?.documents.map({ (snapshot) -> User in
                let dic = snapshot.data()
                let user = User(dic: dic)
                return user
            })
            completion(users ?? [User]())
        }
    }


}
