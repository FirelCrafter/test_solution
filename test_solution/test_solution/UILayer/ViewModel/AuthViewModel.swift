//
//  AuthViewModel.swift
//  test_solution
//
//  Created by Михаил Щербаков on 05.08.2024.
//

import Combine
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var user: User? = nil
    @Published var errorMessage: String?
    @Published var isEmailSent: Bool = false
    private var userRepository: UserRepository
    private var cancellables = Set<AnyCancellable>()

    init(userRepository: UserRepository = UserRepository()) {
        self.userRepository = userRepository
        bindUser()
    }

    func signIn() {
        userRepository.signIn(email: email, password: password)
    }

    func signUp() {
        guard !email.isEmpty else {
            errorMessage = "Email is required"
            Toast.shared.present(title: errorMessage!, symbol: nil)
            return
        }
                
        guard !password.isEmpty else {
            errorMessage = "Password is required"
            Toast.shared.present(title: errorMessage!, symbol: nil)
            return
        }
        
        Auth.auth().fetchSignInMethods(forEmail: email) { [self] methods, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
            } else if let methods = methods, !methods.isEmpty {
                self.errorMessage = "Email is already registered"
                Toast.shared.present(title: self.errorMessage!, symbol: nil)
            } else {
                userRepository.signUp(email: self.email, password: self.password)
            }
        }
        
    }
    
    func resetPassword() {
        guard !email.isEmpty else {
            errorMessage = "Email is required"
            return
        }

        userRepository.resetPassword(email: email)
            .sink { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: {
                self.errorMessage = "Password reset email sent"
            }
            .store(in: &cancellables)
    }
    
    func sendVerificationEmail() {
            userRepository.sendVerificationEmail()
                .sink { completion in
                    if case .failure(let error) = completion {
                        self.errorMessage = error.localizedDescription
                    }
                } receiveValue: {
                    self.isEmailSent = true
                }
                .store(in: &cancellables)
        }

    func signOut() {
        userRepository.signOut()
    }

    private func bindUser() {
        userRepository.$user
            .assign(to: \.user, on: self)
            .store(in: &cancellables)
    }
}
