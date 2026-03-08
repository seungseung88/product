//
//  ProductEditViewModel.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/03/08.
//

import Foundation
import Combine
import RxSwift
import ReSwift

class ProductEditViewModel: ObservableObject, StoreSubscriber {
    
    typealias StoreSubscriberStateType = AppState
    
    
    func newState(state: AppState) {
        DispatchQueue.main.async {
            
        }
    }
}
