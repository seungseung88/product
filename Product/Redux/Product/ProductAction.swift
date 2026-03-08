//
//  ProductAction.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/03/07.
//

import ReSwift

enum ProductAction: Action {
    case fetchProductRequest(String)
    case fetchProductSuccess(Product)
    case fetchProductFailure(Error)
    
    case deleteProductRequest(String)
    case deleteProductSuccess
    case deleteProductFailure(Error)
    
    case createProductRequest(Product)
    case createProductSuccess
    case createProductFailure(Error)
    
    case updateProductRequest(Product)
    case updateProductSuccess
    case updateProductFailure(Error)
}
