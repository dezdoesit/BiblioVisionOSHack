//
//  Chapters.swift
//  Biblio
//
//  Created by Joanna Owczarek on 15/09/2024.
//

import Foundation
import SwiftUI

struct Chapter: Equatable, Hashable {
    let name: String
    let page: Int
    
    static func == (lhs: Chapter, rhs: Chapter) -> Bool {
        return lhs.name == rhs.name && lhs.page == rhs.page
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(page)
    }
}
