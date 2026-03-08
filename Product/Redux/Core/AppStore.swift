//
//  AppStore.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/03/07.
//

import ReSwift

let sharedProductRepository = ProductRepositoryImpl()

let appStore = Store<AppState>(
    reducer: appReducer,
    state: nil,
    middleware: [
        makeProductListMiddleware(repository: sharedProductRepository),
        makeImageMiddleware(repository: sharedProductRepository),
        makeProductMiddleware(repository: sharedProductRepository),
    ]
)
