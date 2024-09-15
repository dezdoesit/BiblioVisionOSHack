//
//  BookDetailViewModel.swift
//  Biblio
//
//  Created by Joanna Owczarek on 15/09/2024.
//

import Foundation
import SwiftUI

class BookDetailViewModel: ObservableObject {
    @Published var content: String?
    @Published var title: String?
    @Published var chapters: [String] = []
    
    let bookService: BookService
    
    init(book: Book) {
        self.bookService = .init(book: book)
        setup()
    }
    
    func setup() {
        self.content = bookService.getBookContent()
        self.title = bookService.getBookTitle()
        self.chapters = bookService.getChapters()
    }
}
