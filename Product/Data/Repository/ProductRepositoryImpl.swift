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



// //
// //  ProductRepositoryImpl.swift
// //  Product
// //
// //  Created by SeungYeong Lee on 2026/03/23.
// //
// import Foundation
// import RxSwift
// // ⭐️ 데이터 변경 상태를 공유하기 위해 반드시 struct가 아닌 'class'로 변경해 줍니다.
// class ProductRepositoryImpl: ProductRepository {
    
//     // ⭐️ 1. 앱이 살아있는 동안 데이터를 들고 있을 가짜 메모리 DB
//     // 앱이 처음 이 Repository를 만들 때 딱 한 번만 JSON을 읽어서 메모리에 올려둡니다.
//     private var inMemoryProducts: [Product] = {
//         do {
//             guard let productDTOs: [ProductDTO] = try Bundle.main.loadAndDecodeJson(filename: "products") else {
//                 return []
//             }
//             return productDTOs.map { $0.toDomain() }
//         } catch {
//             return []
//         }
//     }()
    
//     // ⭐️ 2. 다건 조회 (이제 파일 대신 메모리 배열에서 꺼내줍니다)
//     func getProducts(name: String = "") -> Single<[Product]> {
//         return Single.create { [weak self] single in
//             guard let self = self else { return Disposables.create() }
            
//             var filteredProducts = self.inMemoryProducts
            
//             if !name.isEmpty {
//                 filteredProducts = filteredProducts.filter { $0.name.contains(name) }
//             }
            
//             // 파일 읽는 과정이 사라져서 0.001초만에 바로 응답합니다!
//             single(.success(filteredProducts))
            
//             return Disposables.create()
//         }
//     }
    
//     // ⭐️ 3. 단건 조회 (상세 화면에서 쓸 수도 있으니 미리 만들어 둡니다)
//     func getProduct(id: String) -> Single<Product> {
//         return Single.create { [weak self] single in
//             guard let self = self else { return Disposables.create() }
            
//             if let product = self.inMemoryProducts.first(where: { $0.id == id }) {
//                 single(.success(product))
//             } else {
//                 single(.failure(APIError.fileNotFound)) // 404 Not Found 에러 흉내
//             }
//             return Disposables.create()
//         }
//     }
    
//     // ⭐️ 4. 단건 삭제 (메모리 배열에서 실제로 지워버림!)
//     func deleteProduct(id: String) -> Single<Void> {
//         return Single.create { [weak self] single in
//             guard let self = self else { return Disposables.create() }
            
//             // 배열에서 해당 ID를 제거합니다.
//             self.inMemoryProducts.removeAll { $0.id == id }
            
//             // 서버 통신하는 "척"을 위해 1초 대기 후 성공 반환!
//             DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                 single(.success(()))
//             }
            
//             return Disposables.create()
//         }
//     }
    
//     // 원래 잘 작동하던 이미지 조회 로직 (얘는 JSON을 그대로 읽어도 무방하지만,
//     // 나중에 이미지도 삭제 테스트를 하려면 이쪽도 inMemoryImages 배열로 빼시면 완벽합니다!)
//     func getProductImage(productId: String) -> Single<Data> {
//         return Single.create { single in
//             do {
//                 guard let productImageDTOs: [ProductImageDTO] = try Bundle.main.loadAndDecodeJson(filename: "productImages") else {
//                     single(.failure(APIError.fileNotFound))
//                     return Disposables.create()
//                 }
                
//                 if let targetDTO = productImageDTOs.first(where: { $0.productId == productId }) {
//                     if let imageData = Data(base64Encoded: targetDTO.productImage) {
//                         single(.success(imageData))
//                     } else {
//                         single(.failure(APIError.decodeError))
//                     }
//                 } else {
//                     single(.failure(APIError.fileNotFound))
//                 }
//             } catch {
//                 single(.failure(APIError.decodeError))
//             }
            
//             return Disposables.create()
//         }
//     }
// }

// import ReSwift
// enum ProductAction: Action {
//     // 단일 조회 
//     case getProductRequest(id: String)
//     case getProductSuccess(Product)
//     case getProductFailure(Error)
    
//     // 삭제
//     case deleteProductRequest(id: String)
//     case deleteProductSuccess  // 💡 어차피 리스트화면은 통신을 다시 할테니 누가 지워졌는지 세세한 데이터(id)를 액션에 실어 보낼 필요도 없습니다!
//     case deleteProductFailure(Error)
    
//     case clearError
// }
// // 🗑️ SharedProductAction은 아예 지워버리셔도 됩니다!