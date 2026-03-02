//
//  ProductStubProvider.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/02/28.
//

import Foundation

enum ProductStubProvider {
    static let stubbedProducts: [Product] = {
        guard let productDTOs: [ProductDTO] = try? Bundle.main.loadAndDecodeJson(filename: "products") else {
            fatalError("Failed to load products from stubbed JSON")
        }
        
        guard let productImageDTOs: [ProductImageDTO] = try? Bundle.main.loadAndDecodeJson(filename: "productImages") else {
            fatalError("Failed to load ProductImages from stubbed JSON")
        }
        
        let products: [Product] = productDTOs.map { product in
            let productImageDTO = productImageDTOs.first(where: { $0.productId == product.id })
            
            var decodedData: Data? = nil
            if let productImageDTO {
                decodedData = Data(base64Encoded: productImageDTO.productImage)
            }
            
            return Product(
                id: product.id,
                name: product.name,
                price: product.price,
                description: product.description,
                imageData: decodedData
            )
        }
        
        return products
    }()
}
