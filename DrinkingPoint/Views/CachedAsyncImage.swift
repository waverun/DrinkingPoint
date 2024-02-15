import SwiftUI

struct CachedAsyncImage: View {
    let url: URL
    @State private var image: UIImage?

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
            } else {
                ProgressView()
                    .onAppear {
                        loadImage()
                    }
            }
        }
    }

    private func loadImage() {
        let cacheKey = NSURL(string: url.absoluteString)!

        // Check cache first
        if let cachedImage = ImageCache.shared.image(for: cacheKey) {
            self.image = cachedImage
            return
        }

        // Load from network
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, let downloadedImage = UIImage(data: data) else {
                return
            }
            DispatchQueue.main.async {
                self.image = downloadedImage
                ImageCache.shared.setImage(downloadedImage, for: cacheKey)
            }
        }.resume()
    }
}
