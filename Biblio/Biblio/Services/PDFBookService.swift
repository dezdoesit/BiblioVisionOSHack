//
//  PDFBookService.swift
//  Biblio
//
//  Created by Joanna Owczarek on 15/09/2024.
//

import Foundation
import PDFKit

struct PDFBookService: BookServiceProtocol {
    let book: Book
    
    init(book: Book) {
        self.book = book
    }
    
    var document: PDFDocument? {
        guard let url = book.fileURL else { return nil }
        guard let document = PDFDocument(url: url) else { return nil }
        return document
    }
    
    func getBookContent() -> String? {
        guard let document = document else { return nil }
        return document.string
    }
    
    func getBookTitle() -> String? {
        guard let document = document else { return nil }
        if let title = document.documentAttributes?[PDFDocumentAttribute.titleAttribute] as? String {
            return title
        } else {
            return book.name
        }
    }
    
    func getChapters() -> [String] {
        guard let document = document else { return [] }
        if let extractedChapters = extractChaptersFromTOC(document: document) {
            return extractedChapters.map { $0.name }
        } else {
            return extractChaptersFromText(document: document).map { $0.name }
        }
    }
    
    private func extractChaptersFromTOC(document: PDFDocument) -> [Chapter]? {
        guard let outline = document.outlineRoot else { return nil }
        var extractedChapters: [Chapter] = []
        
        func traverseOutline(_ node: PDFOutline, level: Int) {
            if level == 1, let label = node.label {
                if let destination = node.destination,
                   let page = destination.page {
                    let pageNumber = document.index(for: page)
                    extractedChapters.append(Chapter(name: label, page: pageNumber + 1))
                }
            }
            
            for i in 0..<node.numberOfChildren {
                guard let child = node.child(at: i) else { continue }
                traverseOutline(child, level: level + 1)
            }
        }
        
        traverseOutline(outline, level: 0)
        return extractedChapters.isEmpty ? nil : extractedChapters
    }
    
    private func extractChaptersFromText(document: PDFDocument) -> [Chapter] {
        var extractedChapters: [Chapter] = []
        
        for i in 0..<document.pageCount {
            guard let page = document.page(at: i),
                  let content = page.string else { continue }
            
            if let range = content.range(of: "^Chapter\\s+\\d+", options: [.regularExpression, .caseInsensitive]) {
                let chapterTitle = String(content[range])
                extractedChapters.append(Chapter(name: chapterTitle, page: i + 1))
            }
        }
        
        return extractedChapters
    }
}
