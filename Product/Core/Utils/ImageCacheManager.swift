//
//  ImagaCacheManager.swift
//  Product
//
//  Created by SeungYeong Lee on 2026/03/01.
//

import UIKit

protocol ImageCacheType {
    func getCachedImage(for id: String) -> UIImage?
    func setImage(_ image: UIImage, for id: String)
}

final class ImageCacheManager: ImageCacheType {
    static let shared = ImageCacheManager()
    private init() { }
    
    private let storage = NSCache<NSString, UIImage>()
    
    func getCachedImage(for id: String) -> UIImage? {
        return storage.object(forKey: NSString(string: id))
    }
    
    func setImage(_ image: UIImage, for id: String) {
        storage.setObject(image, forKey: NSString(string: id))
    }
}
