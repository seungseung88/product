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
                
                next(action)
                
                if let productAction = action as? ProductListAction, case .fetchProductsRequest = productAction {
                    let query = getState()?.productListState.keyword ?? ""
                    
                    repository.getProducts(name: query)
                        .subscribe(
                            onSuccess: { products in
                                dispatch(ProductListAction.fetchProductsSuccess(products))
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
