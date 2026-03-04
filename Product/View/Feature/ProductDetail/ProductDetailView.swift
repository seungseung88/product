//
//  ProductDetailView.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/03/04.
//

import SwiftUI

struct ProductDetailView: View {
    
    let productId: String
    let product: Product
    
    init(productId: String) {
        self.productId = productId
        self.product = ProductStubProvider.stubbedProducts.first(where: { $0.id == productId })!
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16)  {
                ImageField(product: product)
                    .frame(height: 260)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                NameField(product: product)
                PriceField(product: product)
                DescriptionField(product: product)
            }
        }
        .navigationTitle("상품 상세")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    // 편집모드
                } label: {
                    Image(systemName: "pencil")
                }
            }
        }
        .padding(16)
        .safeAreaInset(edge: .bottom) {
            HStack {
                Spacer()
                Button(role: .destructive) {
                    
                } label: {
                    Image(systemName: "trash")
                        .padding()
                        .background(.red)
                        .foregroundStyle(.white)
                        .clipShape(.circle)
                }
                .padding(.trailing, 24)
            }
        }
    }
}

private struct ImageField: View {
    let product: Product
    
    var body: some View {
        Group {
            if let imageData = product.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    Color(.secondarySystemBackground)
                    Image(systemName: "photo")
                }
            }
        }
    }
}

private struct NameField: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("상품명")
                .font(.headline)
            
            Text(product.name)
                .font(.subheadline)
        }
    }
}

private struct PriceField: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("판매가격")
                .font(.headline)
            
            HStack(alignment: .bottom, spacing: 4) {
                Text("₩")
                    .font(.caption)
                
                Text(product.price.formattedPrice)
                    .font(.subheadline)
            }
        }
    }
}

private struct DescriptionField: View {
    let product: Product
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("상품상세")
                .font(.headline)
            
            Text(product.description)
                .font(.subheadline)
        }
    }
}

#Preview {
    ProductDetailView(productId: "3")
}
