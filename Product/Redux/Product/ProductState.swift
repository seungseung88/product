//
//  ProductState.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/03/07.
//

struct ProductState {
    
    var product: Product?
    
    // getProduct
    var isFetching = false
    var fetchError: Error?
    
    // deleteProduct
    var isDeleting = false
    var deleteError: Error?
    
    // createProduct
    var isCreating = false
    var createError: Error?
    
    // updateProduct
    var isUpdating = false
    var updateError: Error?
}
