//
//  DefaultNetworkClien.swift
//  PlaylistTestTask
//
//  Created by Elena Noack on 01.02.23.
//

import Foundation

protocol NetworkClient {
    func perform<T: Decodable>(request: URLRequest) async throws -> T
}

final class DefaultNetworkClient: NetworkClient {
    
    // MARK: - Properties
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        return decoder
    }()
    
    private let urlSession: URLSession
    
    // MARK: - Init
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    // MARK: - Methods
    func perform<T: Decodable>(request: URLRequest) async throws -> T {
        let (data, response) = try await urlSession.data(for: request)
        
        guard let response = response as? HTTPURLResponse,
              response.statusCode == 200 else {
            throw (NetworkError.invalidStatusCode)
        }
        
        do {
            let result = try decoder.decode(T.self, from: data)
            return result
        } catch {
            throw (NetworkError.decoding)
        }
    }
    
}
