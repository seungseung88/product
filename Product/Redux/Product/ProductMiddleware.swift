//
//  ProductMiddleware.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/03/07.
//

import RxSwift
import ReSwift

func makeProductMiddleware(repository: ProductRepository) -> Middleware<AppState> {
    let disposeBag = DisposeBag()
    
    return { dispatch, getState in
        { next in
            { action in
                next(action)
                
                if let productAction = action as? ProductAction {
                    if case let .fetchProductRequest(id) = productAction {
                        repository.getProduct(id: id)
                            .subscribe(
                                onSuccess: { product in
                                    dispatch(ProductAction.fetchProductSuccess(product))
                                },
                                onFailure: { error in
                                    dispatch(ProductAction.fetchProductFailure(error))
                                }
                            )
                            .disposed(by: disposeBag)
                    }
                    
                    if case let .deleteProductRequest(id) = productAction {
                        repository.deleteProduct(id: id)
                            .subscribe(
                                onSuccess: {
                                    dispatch(ProductAction.deleteProductSuccess)
                                    dispatch(ProductListAction.showToast)
                                },
                                onFailure: { error in
                                    dispatch(ProductAction.deleteProductFailure(error))
                                }
                            )
                            .disposed(by: disposeBag)
                    }
                }
            }
        }
    }
}
