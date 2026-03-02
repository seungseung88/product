//
//  ImageLoader.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/02/28.
//

import SwiftUI
import RxSwift
import Combine

@MainActor
final class ImageLoader: ObservableObject {
    
    // @Published 프로퍼티는 isLoading, image 변경은 옵저버들에게 화면을 다시 그리라는 신호를 보냄 이는 반드시 Main Thread에서 수행되어야 함
    @Published private(set) var image: UIImage?
    @Published private(set) var isLoading = false
    
    private let disposeBag = DisposeBag()
    private let imageCache: ImageCacheType
    private let productRepository = MockProductRepository()
    
    init(imageCache: ImageCacheType? = nil) {
        self.imageCache = imageCache ?? ImageCacheManager.shared
    }
    
    func loadImage(from productId: String) {
        
        // 로딩 중일 때 중복 요청 방지
        guard !isLoading else { return }
        
        // 캐쉬 확인
        if let cachedImage = imageCache.getCachedImage(for: productId) {
            self.image = cachedImage
            return
        }
        
        // 비동기 객체 생성
        productRepository.getProductImage(productId: productId)
            .map { imageData -> UIImage? in
                return UIImage(data: imageData)
            }
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { decodedImage in
                    guard let decodedImage else { return }
                    self.isLoading = false
                    self.imageCache.setImage(decodedImage, for: productId)
                    self.image = decodedImage
                },
                onFailure: { error in
                    self.isLoading = false
                    print("이미지 로드 실패!")
                }
            )
            .disposed(by: disposeBag)
    }
}

