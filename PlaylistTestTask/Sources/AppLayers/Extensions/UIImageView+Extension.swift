//
//  UIImageView.swift
//  PlaylistTestTask
//
//  Created by Elena Noack on 01.02.23.
//

import UIKit

extension UIImageView {

    private var imageLoader: ImageLoaderService {
        ImageLoaderService(cacheCountLimit: 100)
    }

    @MainActor
    func setImage(with stringURL: String) async throws {
        if let url = URL(string: stringURL) {
            let image = try await imageLoader.loadImage(for: url)
            if !Task.isCancelled {
                self.image = image
            }
        }
    }

}
