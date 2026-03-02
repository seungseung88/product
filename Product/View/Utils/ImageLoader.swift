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

    private let disposeBag = DisposeBag()
    private let imageCache: ImageCacheType

    init(imageCache: ImageCacheType? = nil) {
        self.imageCache = imageCache ?? ImageCacheManager.shared
    }
    
    func loadImage(from product: Product) {
        guard let imageData = product.imageData else { return }
        
        if let cachedImage = imageCache.getCachedImage(for: product.id) {
            self.image = cachedImage
            return
        }
        
       Single<UIImage?>.create { single in
           let decodedImage = UIImage(data: imageData)
           single(.success(decodedImage))
           return Disposables.create()
       }
       .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
       .observe(on: MainScheduler.instance)
       .subscribe(
           onSuccess: { [weak self] decodedImage in
               guard let self, let decodedImage else { return }
               self.imageCache.setImage(decodedImage, for: product.id)
               self.image = decodedImage
           }
       )
       .disposed(by: disposeBag)
    }
}

