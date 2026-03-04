//
//  ProductImageReducer.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/03/04.
//


import ReSwift

func productImageReducer(action: Action, state: ProductImageState?) -> ProductImageState {
    var state = state ?? ProductImageState()
    
    guard let productImageAction = action as? ProductImageAction else {
        return state
    }
    
    switch productImageAction {
    case let .fetchImageRequest(productId):
        state.productImageIDs.insert(productId)
    case let .fetchImageSuccess(productId, _):
        state.productImageIDs.remove(productId)
    case let .fetchImageFailure(productId, errorMessage):
        state.productImageIDs.remove(productId)
    }
    
    return state
}
