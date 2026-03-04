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
    case let .fetchProductsFailure(error):
        state.error = error
        state.isLoading = false
    case .clearError:
        state.error = nil
    }
    
    return state
}
