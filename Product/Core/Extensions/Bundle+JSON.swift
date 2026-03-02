//
//  Bundle+JSON.swift
//  Product
//

import Foundation

extension Bundle {
    func loadAndDecodeJson<D: Decodable>(filename: String) throws -> D? {
        guard let url = self.url(forResource: filename, withExtension: "json") else {
            return nil
        }
        
        let data = try Data(contentsOf: url)
        let jsonDecoder = JSONDecoder()
        let decodedModel = try jsonDecoder.decode(D.self, from: data)
        
        return decodedModel
    }
}
