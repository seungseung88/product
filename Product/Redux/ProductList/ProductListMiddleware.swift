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
                                dispatch(ProductListAction.fetchProductsFailure(error))
                            }
                        )
                        .disposed(by: disposeBag)
                }
            }
        }
    }
}
