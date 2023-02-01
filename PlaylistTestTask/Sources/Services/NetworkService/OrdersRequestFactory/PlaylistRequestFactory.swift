//
//  PlaylistRequestFactory.swift
//  PlaylistTestTask
//
//  Created by Elena Noack on 01.02.23.
//

import Foundation

enum PlaylistRequestFactory {
    
    case playlist
    
    var urlReques: URLRequest {
        switch self {
        case .playlist:
            return createRequest(url: "http://test.iospro.ru/playlistdata.json")
        }
    }
    private func createRequest(url: String) -> URLRequest {
        let url = URL(string: url) ?? URL(fileURLWithPath: "")
        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad
        request.timeoutInterval = 10
        return request
    }
    
}
