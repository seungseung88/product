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
    @State private var showToastMessage = false
    @StateObject private var viewModel = ProductListViewModel()
    
    init(viewModel: ProductListViewModel = ProductListViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.isLoading {
                    ProductListSkeleton()
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
            .navigationDestination(for: String.self) { productId in
                ProductDetailView(productId: productId)
            }
            .searchable(text: $viewModel.keyword)
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
//            .onChange(of: viewModel.errorMessage) { _, newErrorMessage in
//                if newErrorMessage != nil {
//                    isErrorPresented = true
//                }
//            }
            
        }
        .sheet(isPresented: $isPresentingEditSheet) {
            ProductEditView(mode: .create)
        }
        .refreshable {
            viewModel.loadProducts()
        }
        .onAppear {
            viewModel.loadProducts()
        }
        .listFetchErrorAlert(isPresented: $isErrorPresented) {
            viewModel.clearError()
        }
        .overlay(alignment: .bottom) {
            if viewModel.isShowingToast {
                SuccessToastView(toastMessage: "삭제 성공")
                    .padding(.bottom, 80)
                    .transition(.move(edge: .bottom))
                    .onAppear {
                        viewModel.hideToast()
                    }
            }
        }
        .animation(.spring(), value: viewModel.isShowingToast)
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

import ReSwift

#Preview("일반") {
    ProductListView()
}

#Preview("Loading View") {
    var mockState = AppState()
    mockState.productListState.isLoading = true
    
    let mockStore = Store<AppState>(
        reducer: { _, state in state ?? mockState },
        state: mockState,
    )
    
    let loadingViewModel = ProductListViewModel(store: mockStore)
    
    return ProductListView(viewModel: loadingViewModel)
}

#Preview("Empty View") {
    var mockState = AppState()
    mockState.productListState.products = []
    
    let mockStore = Store<AppState>(
        reducer: { _, state in state ?? mockState },
        state: mockState,
    )
    
    let emptyViewModel = ProductListViewModel(store: mockStore)
    
    return ProductListView(viewModel: emptyViewModel)
}
