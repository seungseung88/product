//
//  ProductListViewModel.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/03/01.
//

import Foundation
import ReSwift
import Combine


// ObservableObject를 채택해서 SwiftUI가 이 ViewModel의 변화를 감지
// StoreSubscriber를 채택해서 Redux Store의 변화를 감지
class ProductListViewModel: ObservableObject, StoreSubscriber {
   
   typealias StoreSubscriberStateType = ProductListState
    
    // View가 바라볼 상태들
    @Published var products: [Product] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    @Published var searchText: String = "" {
        didSet {
            // 1. Redux의 searchQuery 상태 변경
            store.dispatch(ProductListAction.updateSearchQuery(searchText))
            
            // 2. 바뀐 검색어로 다시 API 요청
            store.dispatch(ProductListAction.fetchProductRequest(searchText))
        }
    }
    
    init() {
        // 뷰 모델이 생성될 때 Store를 구독
        store.subscribe(self) { subscription in
            subscription.select { state in state.productListState }
        }
    }
    
    deinit {
        store.unsubscribe(self)
    }
    
    func newState(state: ProductListState) {
        self.products = state.products
        self.isLoading = state.isLoading
        self.errorMessage = state.errorMessage
    }
    
    func onAppear() {
        store.dispatch(ProductListAction.fetchProductRequest(""))
    }
}
