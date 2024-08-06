//
//  ButtonModifier.swift
//  test_solution
//
//  Created by Михаил Щербаков on 06.08.2024.
//

import SwiftUI

struct ButtonModifier: ViewModifier {
    var backgroundColor: Color

    func body(content: Content) -> some View {
        content
            .padding()
            .background(backgroundColor)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding(.top)
    }
}

extension View {
    func buttonStyle(backgroundColor: Color) -> some View {
        self.modifier(ButtonModifier(backgroundColor: backgroundColor))
    }
}
