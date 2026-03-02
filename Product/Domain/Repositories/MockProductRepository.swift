//
//  Product.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/03/23.
//

import Foundation
import RxSwift

struct MockProductRepository: ProductRepository {
    func getProducts(name: String = "") -> Single<[Product]> {

        Single.create { single in 
            
            guard let url = Bundle.main.url(forResource: "products", withExtension: "json") else {
                single(.failure(NSError(domain: "FileNotFound", code: -1, userInfo: nil)))
                return Disposables.create()
            }
            do {
                let data = try Data(contentsOf: url)
                let productDTOs = try JSONDecoder().decode([ProductDTO].self, from: data)

                let products = productDTOs.map { dto in 
                    Product(
                        id: dto.id,
                        name: dto.name,
                        price: dto.price,
                        description: dto.description,
                        imageData: nil
                    )
                }

                if name.isEmpty {
                    single(.success(products))
                } else {
                    let filteredProducts = products.filter { product in
                        product.name.contains(name)
                    }
                    single(.success(filteredProducts))
                }
                
            } catch {
                single(.failure(error))
            }
            
            return Disposables.create()
        }
    }
}


// struct DefaultProductRepository: ProductRepository {
    
//     // 1. 의존성 주입: 통신을 담당할 API Client를 가지고 있습니다.
//     // (물론 나중에는 MockAPIClient를 APIClientProtocol 같은 청사진으로 대체하면 더 좋습니다)
//     let apiClient: MockAPIClient
//     func getProducts(name: String = "") -> Single<[Product]> {
        
//         return Single.create { single in
            
//             // 2. MockAPIClient는 async 함수이므로 Task 블록으로 감싸서 호출합니다.
//             let task = Task {
//                 do {
//                     // API Client를 통해 네트워크 통신으로 DTO 데이터를 가져옴
//                     let response = try await apiClient.getProducts(name: name)
                    
//                     // DTO -> Domain Model 변환 
//                     // (MockAPIClient에서 이미 필터링까지 해서 주므로 우리는 변환만 하면 됩니다!)
//                     let products = response.body.map { dto in
//                         Product(
//                             id: dto.id,
//                             name: dto.name,
//                             price: dto.price,
//                             description: dto.description,
//                             imageData: nil
//                         )
//                     }
                    
//                     single(.success(products))
//                 } catch {
//                     single(.failure(error))
//                 }
//             }
            
//             // Rx 스트림(구독)이 끊어지면 진행 중이던 Task(통신)도 함께 취소합니다.
//             return Disposables.create {
//                 task.cancel()
//             }
//         }
//     }
// }