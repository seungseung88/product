//
//  ProductReducer.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/03/07.
//

import ReSwift

func productReducer(action: Action, state: ProductState?) -> ProductState {
    var state = state ?? ProductState()
    
    guard let productAction = action as? ProductAction else {
        return state
    }
    
    switch productAction {
    // getProduct
    case .fetchProductRequest:
        state.isFetching = true
    case let .fetchProductSuccess(product):
        state.product = product
        state.isFetching = false
    case let .fetchProductFailure(error):
        state.isFetching = false
        state.fetchError = error
        
    // deleteProduct
    case .deleteProductRequest:
        state.isDeleting = true
    case .deleteProductSuccess:
        state.isDeleting = false
    case let .deleteProductFailure(error):
        state.isDeleting = false
        state.deleteError = error
    }
    
    
    return state
}
