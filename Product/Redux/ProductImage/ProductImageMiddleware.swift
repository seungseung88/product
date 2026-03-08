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
                
                if let imageAction = action as? ProductImageAction {
                    if case let .fetchImageRequest(productId) = imageAction {
                        
                        if imageCache.getCachedImage(for: productId) != nil {
                            dispatch(ProductImageAction.fetchImageSuccess(productId: productId))
                            return
                        }
                        
                        repository.getProductImage(productId: productId)
                            .map { UIImage(data: $0) }
                            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
                            .observe(on: MainScheduler.instance)
                            .subscribe(
                                onSuccess: { image in
                                    guard let image else {
                                        dispatch(ProductImageAction.fetchImageFailure(productId: productId))
                                        return
                                    }
                                    
                                    imageCache.setImage(image, for: productId)
                                    dispatch(ProductImageAction.fetchImageSuccess(productId: productId))
                                },
                                onFailure: { _ in
                                    dispatch(ProductImageAction.fetchImageFailure(productId: productId))
                                }
                            )
                            .disposed(by: disposeBag)
                        
                    }
                    
                    if case let .deleteImageRequest(productId) = imageAction {
                        repository.deleteProductImage(productId: productId)
                            .subscribe(
                                onSuccess: {
                                    imageCache.removeImage(for: productId)
                                    dispatch(ProductImageAction.deleteImageSuccess(productId))
                                },
                                onFailure: { _ in
                                    dispatch(ProductImageAction.deleteImageFailure)
                                }
                            )
                            .disposed(by: disposeBag)
                    }
                }
            }
        }
    }
}
