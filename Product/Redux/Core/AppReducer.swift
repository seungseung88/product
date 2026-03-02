//
//  Untitled.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/03/03.
//

import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {
    var state = state ?? AppState()
    
    state.productListState = productListReducer(action: action, state: state.productListState)
    
    return state
}
