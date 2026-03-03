//
//  View+FetchErrorAlert.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/03/04.
//

import SwiftUI

struct FetchErrorAlert: ViewModifier {
    @Binding var isPresented: Bool
    let onDismiss: () -> Void
    
    func body(content: Content) -> some View {
        content
            .alert("확인", isPresented: $isPresented) {
                Button("OK") {
                    onDismiss()
                }
            } message: {
                Text("리스트 불러오기를 실패했습니다.")
            }
    }
}

extension View {
    func listFetchErrorAlert(isPresented: Binding<Bool>, onDismiss: @escaping () -> Void) -> some View {
        modifier(FetchErrorAlert(isPresented: isPresented) {
            onDismiss()
        })
    }
}
