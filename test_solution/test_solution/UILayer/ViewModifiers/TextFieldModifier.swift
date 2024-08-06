//
//  TextFieldModifier.swift
//  test_solution
//
//  Created by Михаил Щербаков on 06.08.2024.
//

import SwiftUI

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(8)
            .padding(.horizontal)
    }
}

extension View {
    func textFieldStyle() -> some View {
        self.modifier(TextFieldModifier())
    }
}
