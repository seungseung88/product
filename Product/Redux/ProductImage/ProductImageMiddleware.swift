//
//  ProductImageMiddleware.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/03/04.
//

import ReSwift
import RxSwift
import UIKit
import Foundation

func makeImageMiddleware(repository: ProductRepository, imageCache: ImageCacheType = ImageCacheManager.shared) -> Middleware<AppState> {
    let disposeBag = DisposeBag()
    
    return { dispatch, getstate in
        { next in
            { action in
                next(action)
                
                if let imageAction = action as? ProductImageAction, case let .fetchImageRequest(productId) = imageAction {
                    
                    // 캐쉬에 존재하면 통신 안 하고 바로 성공 액션을 쏴버림
                    if let cachedImage = imageCache.getCachedImage(for: productId) {
                        dispatch(ProductImageAction.fetchImageSuccess(productId: productId, image: cachedImage))
                        return
                    }
                    
                    // 캐쉬가 없다면, 통신으로 받아옴
                    repository.getProductImage(productId: productId)
                        .map { UIImage(data: $0) }
                        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
                        .observe(on: MainScheduler.instance)
                        .subscribe(
                            onSuccess: { image in
                                guard let image else {
                                    dispatch(ProductImageAction.fetchImageFailure(productId: productId, error: "Decode Error"))
                                    return
                                }
                                
                                // 캐쉬에 저장
                                imageCache.setImage(image, for: productId)
                                dispatch(ProductImageAction.fetchImageSuccess(productId: productId, image: image))
                            },
                            onFailure: { error in
                                dispatch(ProductImageAction.fetchImageFailure(productId: productId, error: error.localizedDescription))
                            }
                        )
                        .disposed(by: disposeBag)
                    
                }
            }
        }
    }
}
