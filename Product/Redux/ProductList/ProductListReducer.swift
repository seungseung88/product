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
    case let .fetchProductsRequest(keyword):
        state.isLoading = true
        state.keyword = keyword
    case let .fetchProductsSuccess(products):
        state.products = products
        state.isLoading = false
    case let .fetchProductsFailure(error):
        state.error = error
        state.isLoading = false
    case .clearError:
        state.error = nil
    case .showToast:
        state.isShowingToast = true
    case .hideToast:
        state.isShowingToast = false
    }
    
    return state
}
