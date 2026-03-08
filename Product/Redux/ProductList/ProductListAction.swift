//
//  ProductAction.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/03/03.
//

import ReSwift
import UIKit

enum ProductListAction: Action {
    case fetchProductsRequest(String)
    case fetchProductsSuccess([Product])
    case fetchProductsFailure(Error)
    case clearError
    case showToast
    case hideToast
}
