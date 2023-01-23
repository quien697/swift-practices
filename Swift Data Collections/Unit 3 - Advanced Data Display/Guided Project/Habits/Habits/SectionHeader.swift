//
//  SectionHeader.swift
//  Habits
//
//  Created by Quien on 2023/1/21.
//

import Foundation

enum SectionHeader: String {
    case kind = "SectionHeader"
    case reuse = "HeaderView"
    var identifier: String {
        return rawValue
    }
}
