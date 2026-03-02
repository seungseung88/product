//
//  Product.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/02/28.
//

import Foundation

struct Product: Identifiable {
    let id: String
    let name: String
    let price: Int
    let description: String
    let imageData: Data?
}
