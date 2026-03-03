//
//  ProductListReducer.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/03/03.
//

import ReSwift

func productListReducer(action: Action, state: ProductListState?) -> ProductListState {
    
    var state = state ?? ProductListState()
    
    guard let productListAction = action as? ProductListAction else {
        return state
    }
    
    switch productListAction {
    case let .updateSearchQuery(query):
        state.searchQuery = query
    case .fetchProductRequest:
        state.isLoading = true
    case let .fetchProductSuccess(products):
        state.products = products
        state.isLoading = false
    case let .fetchProductsFailure(errorMessage):
        state.errorMessage = errorMessage
        state.isLoading = false
    case let .fetchImageRequest(productId):
        state.productImageIDs.insert(productId) // 다운로드 시작
    case let .fetchImageSuccess(productId, _):
        state.productImageIDs.remove(productId)
    case let .fetchImageFailure(productId, errorMessage):
        state.productImageIDs.remove(productId)
    case .clearError:
        state.errorMessage = nil
    }
    
    return state
}
