//
//  PasswordRecoveryView.swift
//  test_solution
//
//  Created by Михаил Щербаков on 06.08.2024.
//

import SwiftUI

struct PasswordRecoveryView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            TextField("Email", text: $authViewModel.email)
                .textFieldStyle()

            if let errorMessage = authViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Button(action: {
                authViewModel.resetPassword()
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Reset Password")
                    .buttonStyle(backgroundColor: .blue)
            }

            Spacer()
        }
        .navigationTitle("Password Recovery")
        .padding()
    }
}

struct PasswordRecoveryView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordRecoveryView(authViewModel: AuthViewModel())
    }
}
