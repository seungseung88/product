//
//  SuccessToastView.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/03/07.
//

import SwiftUI

struct SuccessToastView: View {
    let toastMessage: String
    
    var body: some View {
        Label {
            Text(toastMessage)
        } icon: {
            Image(systemName: "checkmark.circle")
        }
        .foregroundStyle(.white)
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background {
            Capsule()
                .fill(.green)
        }
    }
}

#Preview {
    SuccessToastView(toastMessage: "삭제 성공")
}
