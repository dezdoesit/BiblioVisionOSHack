//
//  BookType.swift
//  Biblio
//
//  Created by Joanna Owczarek on 14/09/2024.
//

import Foundation
import SwiftUI

enum BookType {
    case pdf
    case epub
    case other(String)
    
    init(pathExtension: String) {
        switch pathExtension.lowercased() {
        case "pdf":
            self = .pdf
        case "epub":
            self = .epub
        default:
            self = .other(pathExtension.uppercased())
        }
    }
    
    var displayName: String {
        switch self {
        case .pdf:
            return "PDF"
        case .epub:
            return "EPUB"
        case .other(let ext):
            return ext
        }
    }
    
    var iconName: String {
        switch self {
        case .pdf:
            return "doc.fill"
        case .epub:
            return "book.fill"
        case .other:
            return "doc"
        }
    }
    
    var iconColor: Color {
        switch self {
        case .pdf:
            return .red
        case .epub:
            return .green
        case .other:
            return .gray
        }
    }
}
