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
    case fetchImageSuccess(productId: String, image: UIImage)
    case fetchImageFailure(productId: String, error: String)
}
