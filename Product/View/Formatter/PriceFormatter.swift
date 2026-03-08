//
//  PriceFormatter.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/02/28.
//

import Foundation

enum PriceFormatter {
    private static let formatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.locale = .init(identifier: "ja-JP")
        return numberFormatter
    }()
    
    static func string(from number: Int) -> String {
        return formatter.string(for: number) ?? "\(number)"
    }
}

extension Int {
    var formattedPrice: String {
        PriceFormatter.string(from: self)
    }
}













