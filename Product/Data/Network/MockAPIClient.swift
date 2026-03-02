//
//  MockAPIClient.swift
//  Product
//

import Foundation

final class MockAPIClient {
    static let shared = MockAPIClient()
    
    var apiConfigure: ApiConfigure = .never // 기본값 never로 설정
    
    // In-Memory 데이터를 유지할 변수
    private var cachedProducts: [ProductDTO] = []
    private var cachedImages: [ProductImageDTO] = []
    
    private var hasInitialized = false
    
    private init() {}
    
    /// 초기 데이터베이스 역할을 할 JSON 데이터를 메모리에 적재합니다.
    private func initializeCacheIfNeeded() {
        guard !hasInitialized else { return }
        
        if let defaultProducts: [ProductDTO] = try? Bundle.main.loadAndDecodeJson(filename: "products") {
            self.cachedProducts = defaultProducts
        }
        
        if let defaultImages: [ProductImageDTO] = try? Bundle.main.loadAndDecodeJson(filename: "productImages") {
            self.cachedImages = defaultImages
        }
        
        hasInitialized = true
    }
    
    // MARK: - Product API
    
    /// 상품 목록 조회(다수)
    func getProducts(name: String) async throws -> ApiResponse<[ProductDTO]> {
        try await Task.sleep(nanoseconds: 500_000_000)
        
        switch apiConfigure {
        case .always:
            throw NetworkError.mockError
            
        case .never:
            initializeCacheIfNeeded()
            
            if name.isEmpty {
                return ApiResponse(state: 200, body: cachedProducts)
            } else {
                let filtered = cachedProducts.filter { $0.name.contains(name) }
                return ApiResponse(state: 200, body: filtered)
            }
        }
    }
    
    /// 상품 상세 조회(단일)
    func getProduct(id: String) async throws -> ApiResponse<ProductDTO> {
        try await Task.sleep(nanoseconds: 500_000_000)
        
        switch apiConfigure {
        case .always:
            throw NetworkError.mockError
            
        case .never:
            initializeCacheIfNeeded()
            
            guard let targetProduct = cachedProducts.first(where: { $0.id == id }) else {
                throw NetworkError.notFound
            }
            return ApiResponse(state: 200, body: targetProduct)
        }
    }
    
    /// 상품 추가
    func createProduct(name: String, description: String, price: Int) async throws -> ApiResponse<ProductDTO> {
        try await Task.sleep(nanoseconds: 500_000_000)
        
        switch apiConfigure {
        case .always:
            throw NetworkError.mockError
            
        case .never:
            initializeCacheIfNeeded()
            
            let newProduct = ProductDTO(
                id: UUID().uuidString,
                name: name,
                price: price,
                description: description
            )
            
            cachedProducts.append(newProduct)
            return ApiResponse(state: 201, body: newProduct)
        }
    }
    
    /// 상품 수정
    func updateProduct(id: String, name: String, description: String, price: Int) async throws -> ApiResponse<ProductDTO> {
        try await Task.sleep(nanoseconds: 500_000_000)
        
        switch apiConfigure {
        case .always:
            throw NetworkError.mockError
            
        case .never:
            initializeCacheIfNeeded()
            
            guard let index = cachedProducts.firstIndex(where: { $0.id == id }) else {
                throw NetworkError.notFound
            }
            
            let updatedProduct = ProductDTO(
                id: id,
                name: name,
                price: price,
                description: description
            )
            
            cachedProducts[index] = updatedProduct
            return ApiResponse(state: 200, body: updatedProduct)
        }
    }
    
    /// 상품 삭제
    func deleteProduct(id: String) async throws -> ApiResponse<EmptyResponse> {
        try await Task.sleep(nanoseconds: 500_000_000)
        
        switch apiConfigure {
        case .always:
            throw NetworkError.mockError
            
        case .never:
            initializeCacheIfNeeded()
            
            guard let index = cachedProducts.firstIndex(where: { $0.id == id }) else {
                throw NetworkError.notFound
            }
            
            cachedProducts.remove(at: index)
            // 연관된 이미지 삭제(옵셔널)
            cachedImages.removeAll(where: { $0.productId == id })
            
            return ApiResponse(state: 204, body: EmptyResponse())
        }
    }
    
    // MARK: - ProductImage API
    
    /// 상품 이미지 조회
    func getProductImage(productId: String) async throws -> ApiResponse<ProductImageDTO> {
        try await Task.sleep(nanoseconds: 500_000_000)
        
        switch apiConfigure {
        case .always:
            throw NetworkError.mockError
            
        case .never:
            initializeCacheIfNeeded()
            
            guard let targetImage = cachedImages.first(where: { $0.productId == productId }) else {
                throw NetworkError.notFound
            }
            return ApiResponse(state: 200, body: targetImage)
        }
    }
    
    /// 상품 이미지 업로드
    func uploadProductImage(productId: String, productImage: String) async throws -> ApiResponse<ProductImageDTO> {
        try await Task.sleep(nanoseconds: 500_000_000)
        
        switch apiConfigure {
        case .always:
            throw NetworkError.mockError
            
        case .never:
            initializeCacheIfNeeded()
            
            let newImageDTO = ProductImageDTO(productId: productId, productImage: productImage)
            
            if let index = cachedImages.firstIndex(where: { $0.productId == productId }) {
                cachedImages[index] = newImageDTO
            } else {
                cachedImages.append(newImageDTO)
            }
            
            return ApiResponse(state: 201, body: newImageDTO)
        }
    }
    
    /// 상품 이미지 삭제
    func deleteProductImage(productId: String) async throws -> ApiResponse<EmptyResponse> {
        try await Task.sleep(nanoseconds: 500_000_000)
        
        switch apiConfigure {
        case .always:
            throw NetworkError.mockError
            
        case .never:
            initializeCacheIfNeeded()
            
            guard let index = cachedImages.firstIndex(where: { $0.productId == productId }) else {
                throw NetworkError.notFound
            }
            
            cachedImages.remove(at: index)
            
            return ApiResponse(state: 204, body: EmptyResponse())
        }
    }
}
