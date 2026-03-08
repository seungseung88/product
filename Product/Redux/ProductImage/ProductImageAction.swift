//
//  ProductImageAction.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/03/04.
//

import UIKit
import ReSwift

enum ProductImageAction: Action {
    case fetchImageRequest(productId: String)
    case fetchImageSuccess(productId: String)
    case fetchImageFailure(productId: String)
    
    case deleteImageRequest(String)
    case deleteImageSuccess(String)
    case deleteImageFailure

    case uploadImageRequest(productId: String, imageData: Data)
    case uploadImageSuccess(String)
    case uploadImageFailure
}
