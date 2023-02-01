//
//  Constants.swift
//  PlaylistTestTask
//
//  Created by Elena Noack on 01.02.23.
//

import UIKit

enum Constants {

    enum Strings {
        static let searchControllerPlaceholder = "Искать в плейлистах"
        static let navigationControllerTitle = "Плейлисты"
        static let edit = "Редактировать"
        static let hide = "Скрыть"
        static let alertWarning = "Упс! Что-то пошло не так..."
        static let ок = "ОК"
        static let title = "Название"
    }

    enum Fonts {
        static let title = UIFont.systemFont(ofSize: 20, weight: .regular)
        static let subtitle = UIFont.systemFont(ofSize: 18, weight: .regular)

    }

    enum Size {
        static let titleTextFieldHeight: CGFloat = 44
        static let tableViewHeight: CGFloat = 140
    }

}
