//
//  TitleTextField.swift
//  PlaylistTestTask
//
//  Created by Elena Noack on 01.02.23.
//

import UIKit

final class TitleTextField: UITextField {
    init(with title: String) {
        super.init(frame: .zero)

        backgroundColor = .systemGray6
        clearButtonMode = .always
        placeholder = title
        autocorrectionType = .yes
        returnKeyType = .done
        borderStyle = .bezel
        layer.borderColor = UIColor.systemGray2.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
