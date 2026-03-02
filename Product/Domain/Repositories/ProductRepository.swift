//
//  Product.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/02/28.
//

import RxSwift

protocol ProductRepository {
    func getProducts(name: String) -> Single<[Product]>
}
