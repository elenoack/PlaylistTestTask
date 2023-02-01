//
//  String+Extension.swift
//  PlaylistTestTask
//
//  Created by Elena Noack on 01.02.23.
//

import Foundation

extension Optional where Wrapped == String {
    
    var isEmptyOrNil: Bool {
        return self?.isEmpty != false
    }
    
}
