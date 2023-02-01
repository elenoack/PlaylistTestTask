//
//  PlayListDTO.swift
//  PlaylistTestTask
//
//  Created by Elena Noack on 01.02.23.
//

import Foundation

struct PlayListDTO: Decodable {
    let albums: [Album]
}

struct Album: Decodable {
    let title: String
    let subtitle: String
    let image: String
}
