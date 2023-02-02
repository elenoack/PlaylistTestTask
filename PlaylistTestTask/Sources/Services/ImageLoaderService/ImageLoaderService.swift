//
//  ImageLoaderService.swift
//  PlaylistTestTask
//
//  Created by Elena Noack on 01.02.23.
//

import UIKit

actor ImageLoaderService: Actor {

    // MARK: - Properties
    private var cache = NSCache<NSURL, UIImage>()
    private let urlSession: URLSession = .shared

    // MARK: - Init
    init(cacheCountLimit: Int) {
        cache.countLimit = cacheCountLimit
    }

    // MARK: - Methods
    func loadImage(for url: URL) async throws -> UIImage {
        if let image = lookUpCache(for: url) {
            return image
        }
        let image = try await doLoadImage(for: url)
        updateCache(image: image, and: url)
        return lookUpCache(for: url) ?? image
    }

    // MARK: - Private
    private func doLoadImage(for url: URL) async throws -> UIImage {
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await urlSession.data(for: urlRequest)
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
            throw (NetworkError.invalidStatusCode)
        }
        guard let image = UIImage(data: data) else {
            throw (NetworkError.decoding)
        }
        return image
    }
    
    private func lookUpCache(for url: URL) -> UIImage? {
        return cache.object(forKey: url as NSURL)
    }
    
    private func updateCache(image: UIImage, and url: URL) {
        if cache.object(forKey: url as NSURL) == nil {
            cache.setObject(image, forKey: url as NSURL)
        }
    }
    
}
