//
//  NetworkError.swift
//  PlaylistTestTask
//
//  Created by Elena Noack on 01.02.23.
//

import Foundation

enum NetworkError: Error {
    case invalidStatusCode
    case emptyData
    case decoding
    case unknown
    
    var errorDescription: String {
        switch self {
        case .invalidStatusCode:
            return "Невалидный URL"
        case .emptyData:
            return "Данные отсутствуют"
        case .decoding:
            return "Ошибка преобразования данных"
        case .unknown:
            return "Неизвестная ошибка"
        }
    }
    
}
