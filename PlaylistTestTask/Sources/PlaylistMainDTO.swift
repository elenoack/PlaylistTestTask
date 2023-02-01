//
//  PlaylistMainDTO.swift
//  PlaylistTestTask
//
//  Created by Elena Noack on 01.02.23.
//

import Foundation

enum PlaylistMainDTO {
    
    enum GetPlaylist {
        struct Request {
            let predicate: String
        }
        struct Response {}
        
        struct ViewModel {
            let request: Album
        }
    }
    
}
