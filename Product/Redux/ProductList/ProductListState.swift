//
//  ProductListState.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/03/03.
//

struct ProductListState {
    var products: [Product] = []
    var isLoading = false
    var errorMessage: String?
    var searchQuery = ""
}
