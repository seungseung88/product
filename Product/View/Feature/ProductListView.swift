//
//  ProductListView.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/02/28.
//

import SwiftUI

struct ProductListView: View {
    
    @State private var isErrorPresented = false
    @State private var isPresentingEditSheet = false
    @StateObject private var viewModel = ProductListViewModel(store: store)
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ListSkeleton()
                } else if viewModel.products.isEmpty {
                    EmptyState()
                } else {
                    List(viewModel.products) { product in
                        NavigationLink(value: product.id) {
                            ProductRow(
                                product: product,
                                image: viewModel.imageCache.getCachedImage(for: product.id)
                            ) {
                                viewModel.loadImage(for: product.id)
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
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
                viewModel.loadProducts()
            }
            .listFetchErrorAlert(isPresented: $isErrorPresented) {
                viewModel.clearError()
            }
            .onChange(of: viewModel.errorMessage) { _, newErrorMessage in
                if newErrorMessage != nil {
                    isErrorPresented = true
                }
            }
            
        }
    }
}

private struct ListSkeleton: View {
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

private struct EmptyState: View {
    var body: some View {
        ContentUnavailableView {
            Label("아이템 없음", systemImage: "shippingbox")
        } description: {
            Text("아이템 추가해주세요")
        }
    }
}

private struct ProductRow: View {
    let product: Product
    let image: UIImage?
    let action: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            productImage
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            productSummary
        }
        .onAppear() {
            action()
        }
    }
    
    private var productImage: some View {
        Group {
            if let image {
                Image(uiImage: image)
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

#Preview("일반") {
    ProductListView()
}

#Preview("Empty View") {
    NavigationStack {
        EmptyState()
            .navigationTitle("상품 관리")
    }
}

#Preview("Skeleton View") {
    NavigationStack {
        ListSkeleton()
            .navigationTitle("상품 관리")
    }
}
