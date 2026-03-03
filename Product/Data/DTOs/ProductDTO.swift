//
//  ProductDTO.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/02/28.
//

struct ProductDTO: Codable {
    let id: String
    let name: String
    let price: Int
    let description: String
}

extension ProductDTO {
    func toDomain() -> Product {
        return Product(
            id: self.id,
            name: self.name,
            price: self.price,
            description: self.description,
            imageData: nil
        )
        
    }
}
