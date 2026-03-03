//
//  ProductListMiddleware.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/03/03.
//

import Foundation
import RxSwift
import ReSwift
import UIKit


func makeProductListMiddleware(repository: ProductRepository) -> Middleware<AppState>  {
    let disposeBag = DisposeBag()

    return { dispatch, getState in
        { next in
            { action in
                
                // 1. 들어온 액션을 일단 Reducer로 보냄 -> 로딩
                next(action)
                
                // 2. 만약 지나간 액션이 fetchProductRequest라면 가로채서 통신 시작
                if let productAction = action as? ProductListAction, case .fetchProductRequest = productAction {
                    let query = getState()?.productListState.searchQuery ?? ""
                    
                    repository.getProducts(name: query)
                        .subscribe(
                            onSuccess: { products in
                                dispatch(ProductListAction.fetchProductSuccess(products))
                            },
                            onFailure: { error in
                                dispatch(ProductListAction.fetchProductsFailure(error.localizedDescription))
                            }
                        )
                        .disposed(by: disposeBag)
                }
            }
        }
    }
}

func makeImageMiddleware(repository: ProductRepository, imageCache: ImageCacheType = ImageCacheManager.shared) -> Middleware<AppState> {
    let disposeBag = DisposeBag()
    
    return { dispatch, getstate in
        { next in
            { action in                
                next(action)
                
                if let imageAction = action as? ProductListAction, case let .fetchImageRequest(productId) = imageAction {
                    
                    // 캐쉬에 존재하면 통신 안 하고 바로 성공 액션을 쏴버림
                    if let cachedImage = imageCache.getCachedImage(for: productId) {
                        print("캐시 히트! 네트워크 안 타고 바로 리턴합니다.")
                        dispatch(ProductListAction.fetchImageSuccess(productId: productId, image: cachedImage))
                        return
                    }
                    
                    // 캐쉬가 없다면, 통신으로 받아옴
                    repository.getProductImage(productId: productId)
                        .map { UIImage(data: $0) }
                        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .userInitiated))
                        .observe(on: MainScheduler.instance)
                        .subscribe(
                            onSuccess: { image in
                                guard let image = image else { 
                                    dispatch(ProductListAction.fetchImageFailure(productId: productId, error: "Decode Error"))
                                    return 
                                }
                                
                                // NSCache에 저장
                                imageCache.setImage(image, for: productId)
                                dispatch(ProductListAction.fetchImageSuccess(productId: productId, image: image))
                            },
                            onFailure: { error in
                                dispatch(ProductListAction.fetchImageFailure(productId: productId, error: error.localizedDescription))
                            }
                        )
                        .disposed(by: disposeBag)
                    
                }
            }
        }
    }
}
