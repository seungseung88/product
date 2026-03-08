//
//  ProductDetailView.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/03/04.
//

import SwiftUI

struct ProductDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var isDeleteAlertPresented = false
    @State private var isPresentedEditSheet = false
    @StateObject var viewModel: ProductDetailViewModel
    
    init(productId: String, viewModel: ProductDetailViewModel? = nil) {
            _viewModel = StateObject(wrappedValue: viewModel ?? ProductDetailViewModel(productId: productId))
        }
    
    var body: some View {
        ScrollView {
            if viewModel.isFetching {
                ProductDetailSkeleton()
            } else if let product = viewModel.product {
                VStack(alignment: .leading, spacing: 16)  {
                    ImageField(
                        uiImage: viewModel.imageCache.getCachedImage(for: product.id)
                    )
                    
                    NameField(product: product)
                    PriceField(product: product)
                    DescriptionField(product: product)
                }
                .padding(16)

            } else {
                EmptyState()
            }
        }
        .navigationTitle("상품 상세")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isPresentedEditSheet = true
                } label: {
                    Image(systemName: "pencil")
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                Spacer()
                DeleteButton() {
                    isDeleteAlertPresented = true
                }
                .padding(.trailing, 24)
                .deleteAlert(isPresented: $isDeleteAlertPresented) {
                    viewModel.deleteProduct()
                }
            }
        }
        .sheet(isPresented: $isPresentedEditSheet) {
            ProductEditView(mode: .edit(productId: viewModel.productId))
        }
        .onChange(of: viewModel.isDeleting) { oldValue, newValue in
            if oldValue && !newValue && viewModel.deleteError == nil {
                dismiss()
            }
        }
        .onAppear {
            viewModel.loadProduct()
            viewModel.loadImageProduct()
        }
    }
}

private struct ImageField: View {
    let uiImage: UIImage?
    
    var body: some View {
        Color(.secondarySystemBackground)
            .overlay {
                if let uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                } else {
                    Image(systemName: "photo")
                }
            }
            .frame(height: 260)
            .clipShape(RoundedRectangle(cornerRadius: 8))
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

private struct DeleteButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(role: .destructive) {
            action()
        } label: {
            Image(systemName: "trash")
                .padding()
                .background(.red)
                .foregroundStyle(.white)
                .clipShape(.circle)
        }

    }
}

import ReSwift

#Preview {
    ProductDetailView(productId: "1")
}

#Preview("Empty View") {
    var mockState = AppState()
    mockState.productState.product = nil
    
    let mockStore = Store<AppState>(
        reducer: { _, state in state ?? mockState },
        state: mockState
    )
    
    return ProductDetailView(
        productId: "1",
        viewModel: ProductDetailViewModel(productId: "1", store: mockStore)
    )
}

#Preview("Loading View") {
    var mockState = AppState()
    mockState.productState.isFetching = true
    
    let mockStore = Store<AppState>(
        reducer: { _, state in state ?? mockState },
        state: mockState
    )
    
    return ProductDetailView(
        productId: "1",
        viewModel: ProductDetailViewModel(productId: "1", store: mockStore)
    )
}
