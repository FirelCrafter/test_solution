//
//  UserRepository.swift
//  test_solution
//
//  Created by Михаил Щербаков on 05.08.2024.
//

import Combine
import FirebaseAuth

class UserRepository: ObservableObject {
    @Published var user: User? = nil
    private var authService: FirebaseAuthService
    private var cancellables = Set<AnyCancellable>()

    init(authService: FirebaseAuthService = .shared) {
        self.authService = authService
        listenToAuthState()
    }

    func signIn(email: String, password: String) {
        authService.signIn(email: email, password: password)
            .sink { completion in
                if case .failure(let error) = completion {
                    Toast.shared.present(title: error.localizedDescription, symbol: nil)
                    print("SignIn Error: \(error.localizedDescription)")
                }
            } receiveValue: { user in
                self.user = user
            }
            .store(in: &cancellables)
    }

    func signUp(email: String, password: String) {
        authService.signUp(email: email, password: password)
            .sink { completion in
                if case .failure(let error) = completion {
                    Toast.shared.present(title: error.localizedDescription, symbol: nil)
                    print("SignUp Error: \(error.localizedDescription)")
                }
            } receiveValue: { user in
                self.user = user
            }
            .store(in: &cancellables)
    }

    func signOut() {
        authService.signOut()
            .sink { completion in
                if case .failure(let error) = completion {
                    Toast.shared.present(title: error.localizedDescription, symbol: nil)
                    print("SignOut Error: \(error.localizedDescription)")
                } else {
                    self.user = nil
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    func sendVerificationEmail() -> Future<Void, Error> {
        return Future { promise in
            guard let user = Auth.auth().currentUser else {
                promise(.failure(NSError(domain: "UserRepository", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user is signed in."])))
                return
            }

            user.sendEmailVerification { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
    }
    
    func resetPassword(email: String) -> Future<Void, Error> {
        return Future { promise in
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
    }

    private func listenToAuthState() {
        Auth.auth().addStateDidChangeListener { _, user in
            self.user = user
        }
    }
}
