//
//  ProductDetailViewModel.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/03/07.
//

import ReSwift
import Combine
import Foundation

class ProductDetailViewModel: ObservableObject, StoreSubscriber {
    typealias StoreSubscriberStateType = AppState
    
    let productId: String
    @Published var product: Product?
    @Published var isFetching = false
    @Published var fetchError: Error?
    @Published var isDeleting = false
    @Published var deleteError: Error?
    
    @Published var loadingImageIDs: Set<String> = []
    
    let imageCache: ImageCacheType
    private let store: Store<AppState>
    
    init(productId: String, store: Store<AppState> = appStore, imageCache: ImageCacheType = ImageCacheManager.shared) {
        self.productId = productId
        self.store = store
        self.imageCache = imageCache
        self.store.subscribe(self)
    }
    
    deinit {
        self.store.unsubscribe(self)
    }
    
    func newState(state: AppState) {
        DispatchQueue.main.async {
            let productState = state.productState
            self.product = productState.product
            self.isFetching = productState.isFetching
            self.fetchError = productState.fetchError
            self.isDeleting = productState.isDeleting
            self.deleteError = productState.deleteError
            
            let productImageState = state.productImageState
            self.loadingImageIDs = productImageState.productImageIDs
            
        }
    }
    
    func loadProduct() {
        store.dispatch(ProductAction.fetchProductRequest(productId))
    }
    
    func loadImageProduct() {
        store.dispatch(ProductImageAction.fetchImageRequest(productId: productId))
    }
    
    func deleteProduct() {
        store.dispatch(ProductAction.deleteProductRequest(productId))
        store.dispatch(ProductImageAction.deleteImageRequest(productId))
    }
}
