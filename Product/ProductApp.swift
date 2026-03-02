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
    middleware: [productListMiddleware]
)

@main
struct ProductApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
