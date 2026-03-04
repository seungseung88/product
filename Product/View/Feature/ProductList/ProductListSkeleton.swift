//
//  ProductListSkeleton.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/03/05.
//

import SwiftUI

struct ProductListSkeleton: View {
    var body: some View {
        List(1...3, id: \.self) { _ in
            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.tertiarySystemGroupedBackground))
                    .frame(width: 64, height: 64)
                    
                VStack(alignment: .leading, spacing: 6) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.tertiarySystemGroupedBackground))
                        .frame(height: 16)
                    
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.tertiarySystemGroupedBackground))
                        .frame(width: 120, height: 14)
                }
                .alignmentGuide(.listRowSeparatorLeading) { dimension in
                    dimension[.leading]
                }
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    ProductListSkeleton()
}
