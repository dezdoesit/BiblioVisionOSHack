//
//  BookServiceProtocol.swift
//  Biblio
//
//  Created by Joanna Owczarek on 15/09/2024.
//

import Foundation

protocol BookServiceProtocol {
    func getBookContent() -> String?
    func getBookTitle() -> String?
    func getChapters() -> [String]
}


