//
//  View+Extensions.swift
//  WeatherApp
//
//  Created by Erick Manrique on 9/16/23.
//

import SwiftUI

extension View {
    // Clpsing All Active Keyboards
    func closeKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    // MARK: Disable with Opacity
    func disableWithOpacity(_ condition: Bool) -> some View {
        self.disabled(condition)
            .opacity(condition ? 0.6: 1)
    }
    
    func hAlign(_ alignment: Alignment) -> some View {
        self.frame(maxWidth: .infinity, alignment: alignment)
    }
    
    func vAlign(_ alignment: Alignment) -> some View {
        self.frame(maxHeight: .infinity, alignment: alignment)
    }
    
    func border(_ width: CGFloat,_ color: Color) -> some View {
        self.padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background {
                RoundedRectangle(cornerRadius: 5, style: .continuous)
                    .stroke(color, lineWidth: width)
            }
    }
}

