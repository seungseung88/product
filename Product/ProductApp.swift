//
//  ProductApp.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/02/26.
//

import ReSwift
import SwiftUI

let store = Store<AppState>(
    reducer: appReducer,
    state: nil,
    middleware: [
        makeProductListMiddleware(repository: ProductRepositoryImpl()),
        makeImageMiddleware(repository: ProductRepositoryImpl()),
    ]
)

@main
struct ProductApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
