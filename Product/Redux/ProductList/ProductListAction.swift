//
//  ProductAction.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/03/03.
//

import ReSwift
import UIKit

enum ProductListAction: Action {
    case updateSearchQuery(String)
    case fetchProductRequest
    case fetchProductSuccess([Product])
    case fetchProductsFailure(Error)
    case clearError
}
