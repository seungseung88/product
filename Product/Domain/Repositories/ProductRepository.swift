//
//  Product.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/02/28.
//

import Foundation
import RxSwift

protocol ProductRepository {
    func getProducts(name: String) -> Single<[Product]>
    func getProductImage(productId: String) -> Single<Data>
}
