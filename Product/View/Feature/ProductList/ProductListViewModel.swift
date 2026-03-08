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
import SwiftUI

class ProductListViewModel: ObservableObject, StoreSubscriber {
    
    typealias StoreSubscriberStateType = AppState
    
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var error: Error?
    @Published var keyword = ""
    @Published var isShowingToast = false
    
    @Published var loadingImageIDs: Set<String> = []
    
    let imageCache: ImageCacheType
    private let store: Store<AppState>
    private var cancellables = Set<AnyCancellable>()
    
    init(store: Store<AppState> = appStore, imageCache: ImageCacheType = ImageCacheManager.shared) {
        self.store = store
        self.imageCache = imageCache
        self.store.subscribe(self)
        bindingKeyword()
    }
    
    deinit {
        store.unsubscribe(self)
    }
    
    func newState(state: AppState) {
        DispatchQueue.main.async {
            let productListState = state.productListState
            self.products = productListState.products
            self.isLoading = productListState.isLoading
            self.error = productListState.error
            self.keyword = productListState.keyword
            self.isShowingToast = productListState.isShowingToast
            
            let productImageState = state.productImageState
            self.loadingImageIDs = productImageState.productImageIDs
        }
        
    }
    
    func loadProducts() {
        store.dispatch(ProductListAction.fetchProductsRequest(keyword))
    }
    
    func loadImage(for productId: String) {
        // 이미 이미지를 로드 중일 때 요청안함
        guard !loadingImageIDs.contains(productId) else { return }
        store.dispatch(ProductImageAction.fetchImageRequest(productId: productId))
    }
    
    func clearError() {
        store.dispatch(ProductListAction.clearError)
    }
    
    func hideToast() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.store.dispatch(ProductListAction.hideToast)
        }
    }
    
    private func bindingKeyword() {
        $keyword
            .dropFirst()
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { keyword in
                self.store.dispatch(ProductListAction.fetchProductsRequest(keyword))
            }
            .store(in: &cancellables)
    }
}
