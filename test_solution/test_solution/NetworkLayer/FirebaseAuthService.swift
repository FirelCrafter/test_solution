//
//  FirebaseAuthService.swift
//  test_solution
//
//  Created by Михаил Щербаков on 05.08.2024.
//

import FirebaseAuth
import Combine

class FirebaseAuthService {
    static let shared = FirebaseAuthService()
    private init() {}

    func signIn(email: String, password: String) -> Future<User, Error> {
        return Future { promise in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    promise(.failure(error))
                } else if let user = authResult?.user {
                    promise(.success(user))
                }
            }
        }
    }

    func signUp(email: String, password: String) -> Future<User, Error> {
        return Future { promise in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    promise(.failure(error))
                } else if let user = authResult?.user {
                    promise(.success(user))
                }
            }
        }
    }

    func signOut() -> Future<Void, Error> {
        return Future { promise in
            do {
                try Auth.auth().signOut()
                promise(.success(()))
            } catch let signOutError as NSError {
                promise(.failure(signOutError))
            }
        }
    }
}
