//
//  ProductListViewModel.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/03/01.
//

import Foundation
import ReSwift
import Combine
import UIKit


// ObservableObject를 채택해서 SwiftUI가 이 ViewModel의 변화를 감지
// StoreSubscriber를 채택해서 Redux Store의 변화를 감지
struct ProductListViewState: Equatable {
    let products: [Product]
    let isLoading: Bool
    let errorMessage: String?
    let loadingImageIDs: Set<String>
}

class ProductListViewModel: ObservableObject, StoreSubscriber {
    
    typealias StoreSubscriberStateType = ProductListViewState
    
    // View가 바라볼 상태들
    @Published var products: [Product] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var searchText: String = ""
    @Published var loadingImageIDs: Set<String> = []
    
    let imageCache: ImageCacheType
    private let store: Store<AppState>
    private var cancellables = Set<AnyCancellable>()
    
    init(store: Store<AppState>, imageCache: ImageCacheType = ImageCacheManager.shared) {
        self.store = store
        self.imageCache = imageCache
        // 뷰 모델이 생성될 때 Store를 구독
        store.subscribe(self) { subscription in
            subscription.select { state in
                ProductListViewState(
                    products: state.productListState.products,
                    isLoading: state.productListState.isLoading,
                    errorMessage: state.productListState.error?.localizedDescription,
                    loadingImageIDs: state.productImageState.productImageIDs
                )
            }.skipRepeats()
        }
        binding()
    }
    
    private func binding() {
        $searchText
            .dropFirst()
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { searchText in
                // 1. Redux의 searchQuery 상태 변경
                self.store.dispatch(ProductListAction.updateSearchQuery(searchText))
                
                // 2. 바뀐 검색어로 다시 API 요청
                self.store.dispatch(ProductListAction.fetchProductRequest)
            }
            .store(in: &cancellables)
    }
    
    deinit {
        store.unsubscribe(self)
    }
    
    func newState(state: ProductListViewState) {
        self.products = state.products
        self.isLoading = state.isLoading
        self.errorMessage = state.errorMessage
        self.loadingImageIDs = state.loadingImageIDs
    }
    
    func loadProducts() {
        store.dispatch(ProductListAction.fetchProductRequest)
    }
    
    func loadImage(for productId: String) {
        // 이미 이미지를 로드 중일 때 요청안함
        guard !loadingImageIDs.contains(productId) else { return }
        store.dispatch(ProductImageAction.fetchImageRequest(productId: productId))
    }
    
    func clearError() {
        store.dispatch(ProductListAction.clearError)
    }
}
