//
//  SignUpView.swift
//  test_solution
//
//  Created by Михаил Щербаков on 05.08.2024.
//

import SwiftUI

import SwiftUI

struct SignUpView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            TextField("Email", text: $authViewModel.email)
                .textFieldStyle()

            SecureField("Password", text: $authViewModel.password)
                .textFieldStyle()

            if let errorMessage = authViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button(action: {
                authViewModel.signUp()
            }) {
                Text("Sign Up")
                    .buttonStyle(backgroundColor: .green)
            }

            Spacer()
        }
        .navigationTitle("Sign Up")
        .padding()
        .onReceive(authViewModel.$isEmailSent) { isEmailSent in
            if isEmailSent {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView(authViewModel: AuthViewModel())
    }
}
