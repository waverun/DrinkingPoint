import Foundation
import UIKit

class ImageCache {
    static let shared = ImageCache()
    private init() {}

    private var cache = NSCache<NSURL, UIImage>()

    func image(for url: NSURL) -> UIImage? {
        return cache.object(forKey: url)
    }

    func setImage(_ image: UIImage, for url: NSURL) {
        cache.setObject(image, forKey: url)
    }
}
