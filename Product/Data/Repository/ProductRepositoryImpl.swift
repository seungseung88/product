//
//  ProductRepositoryImpl.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/03/23.
//

import Foundation
import RxSwift

struct ProductRepositoryImpl: ProductRepository {
    func getProducts(name: String = "") -> Single<[Product]> {
        return Single.create { single in
            do {
                guard let productDTOs: [ProductDTO] = try Bundle.main.loadAndDecodeJson(filename: "products") else {
                    single(.failure(APIError.fileNotFound))
                    return Disposables.create()
                }
                
                let products = productDTOs.map { $0.toDomain() }
                var filteredProducts = products
                
                if !name.isEmpty {
                    filteredProducts = products.filter { $0.name.contains(name) }
                }
                
                single(.success(filteredProducts))
                
            } catch {
                single(.failure(APIError.decodeError))
            }
            
            return Disposables.create()
        }
    }
    
    func getProductImage(productId: String) -> Single<Data> {
        return Single.create { single in
            
            
            do {
                guard let productImageDTOs: [ProductImageDTO] = try Bundle.main.loadAndDecodeJson(filename: "productImages") else {
                    single(.failure(APIError.fileNotFound))
                    return Disposables.create()
                }
                
                if let targetDTO = productImageDTOs.first(where: { $0.productId == productId }) {
                    if let imageData = Data(base64Encoded: targetDTO.productImage) {
                        single(.success(imageData))
                    } else {
                        single(.failure(APIError.decodeError))

                    }
                } else {
                    single(.failure(APIError.fileNotFound))
                }
            } catch {
                single(.failure(APIError.decodeError))
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
