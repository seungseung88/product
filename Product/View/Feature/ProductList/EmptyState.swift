//
//  EmptyState.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/03/04.
//

import SwiftUI

struct EmptyState: View {
    var body: some View {
        ContentUnavailableView {
            Label("아이템 없음", systemImage: "shippingbox")
        } description: {
            Text("아이템 추가해주세요")
        }
    }
}
