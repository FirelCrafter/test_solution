//
//  ContentView.swift
//  test_solution
//
//  Created by Михаил Щербаков on 05.08.2024.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var isAuthenticated = false
    @State private var showSignUpSheet = false
    @State private var showPasswordRecoverySheet = false
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            if isAuthenticated {
                HomeView()
                    .navigationBarBackButtonHidden(true)
            } else {
                VStack {
                    TextField("Email", text: $authViewModel.email)
                        .textFieldStyle()
                    SecureField("Password", text: $authViewModel.password)
                        .textFieldStyle()
                    
                    Button {
                        authViewModel.signIn()
                    } label: {
                        Text("Sign In")
                            .buttonStyle(backgroundColor: .blue)
                    }
                    
                    Button {
                        showSignUpSheet.toggle()
                    } label: {
                        Text("Sign Up")
                            .buttonStyle(backgroundColor: .green)
                    }
                    
                    Button {
                        showPasswordRecoverySheet.toggle()
                    } label: {
                        Text("Forgot password")
                            .buttonStyle(backgroundColor: .gray)
                    }
                    .sheet(isPresented: $showPasswordRecoverySheet) {
                        PasswordRecoveryView(authViewModel: authViewModel)
                    }
                    .sheet(isPresented: $showSignUpSheet) {
                        SignUpView(authViewModel: authViewModel)
                    }
                    
                    if let errorMessage = authViewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    }
                }
                .navigationTitle("Login")
                .onReceive(authViewModel.$user, perform: { user in
                    if user != nil {
                        isAuthenticated = true
                    }
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
