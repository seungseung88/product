//
//  ApiResponse.swift
//  Product
//

import Foundation

struct ApiResponse<T> {
    let state: Int
    let body: T
}
