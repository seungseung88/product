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
    func getProduct(id: String) -> Single<Product>
    func deleteProduct(id: String) -> Single<Void>
    func deleteProductImage(productId: String) -> Single<Void>
}
