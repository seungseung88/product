//
//  ProductListView.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/02/28.
//

import SwiftUI

struct ProductListView: View {
    
    @State private var searchText = ""
    @State private var isPresentingEditSheet = false
    @StateObject private var viewModel = ProductListViewModel()
    @StateObject private var imageLoader = ImageLoader()
    
    var body: some View {
        
        NavigationStack {
            List(viewModel.products) { product in
                NavigationLink(value: product.id) {
                    ProductRow(product: product)
                }
            }
            .listStyle(.plain)
            .searchable(text: $viewModel.searchText)
            .navigationTitle("상품 리스트")
            .toolbar {
                ToolbarItem(){
                    Button {
                        isPresentingEditSheet = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isPresentingEditSheet) {
                Text("")
            }
            .navigationDestination(for: String.self) { productId in
                Text("productId: \(productId)")
            }
            .onAppear {
                viewModel.onAppear()
            }
        }
    }
}

private struct ProductRow: View {
    let product: Product
    @StateObject private var imageLoader = ImageLoader()
    
    var body: some View {
        HStack(spacing: 12) {
            productImage
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            productSummary
        }
        .task {
            imageLoader.loadImage(from: product.id)
        }
    }
    
    private var productImage: some View {
        Group {
            if let loadedImage = imageLoader.image {
                Image(uiImage: loadedImage)
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
    
    private var productSummary: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(product.name)
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

#Preview {
    ProductListView()
}
