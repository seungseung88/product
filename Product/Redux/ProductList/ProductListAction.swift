//
//  ProductAction.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/03/03.
//

import ReSwift

enum ProductListAction: Action {
    case updateSearchQuery(String)

    case fetchProductRequest(String)
    case fetchProductSuccess([Product])
    case fetchProductsFailure(String)
}
