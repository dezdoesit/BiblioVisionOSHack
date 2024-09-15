//
//  BookService.swift
//  Biblio
//
//  Created by Joanna Owczarek on 15/09/2024.
//

import Foundation

class BookService : BookServiceProtocol {
    
    private var bookService: BookServiceProtocol?
    
    let book: Book
    
    init(book: Book) {
        self.book = book
        initalizeService()
    }
    
    func initalizeService() {
        switch book.type {
        case .pdf:
            bookService = PDFBookService(book: book)
        case .epub:
            bookService = EPUBBookService(book: book)
        case .other(let _):
            bookService = nil
        }
    }
    
    func getBookTitle() -> String? {
        bookService?.getBookTitle()
    }
    
    func getChapters() -> [String] {
        bookService?.getChapters() ?? []
    }
    
    func getBookContent() -> String? {
        bookService?.getBookContent()
    }
}
