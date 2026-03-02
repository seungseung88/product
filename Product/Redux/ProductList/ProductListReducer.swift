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
    case .updateSearchQuery(let query):
        state.searchQuery = query
    case .fetchProductRequest:
        state.isLoading = true
    case .fetchProductSuccess(let products):
        state.products = products
        state.isLoading = false
    case .fetchProductsFailure(let errorMessage):
        state.errorMessage = errorMessage
        state.isLoading = false
    }
    
    return state
}
