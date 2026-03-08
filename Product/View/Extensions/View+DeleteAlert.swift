//
//  View+DeleteAlert.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/03/07.
//

import SwiftUI

private struct DeleteAlertModifier: ViewModifier {
    
    @Binding var isPresented: Bool
    let onDismiss: () -> Void
    
    func body(content: Content) -> some View {
        content
            .alert("", isPresented: $isPresented) {
                Button("취소", role: .cancel) { }
                Button(role: .destructive) {
                    onDismiss()
                } label: {
                    Text("삭제")
                }
            } message: {
                Text("정말로 삭제하시겠습니까?")
            }
    }
}

extension View {
    func deleteAlert(isPresented: Binding<Bool>, onDismiss: @escaping () -> Void) -> some View {
        modifier(DeleteAlertModifier(isPresented: isPresented){
            onDismiss()
        })
    }
}
