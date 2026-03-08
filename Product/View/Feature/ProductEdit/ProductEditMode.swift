//
//  ProductEditMode.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/03/08.
//

enum ProductEditMode {
    case create
    case edit(productId: String)
    
    var navigationTitle: String {
        switch self {
        case .create:
            "신규 생성"
        case .edit:
            "기존정보 편집"
        }
    }
    
    var buttonLabel: String {
        switch self {
        case .create:
            "등록"
        case .edit:
            "편집"
        }
    }
}
