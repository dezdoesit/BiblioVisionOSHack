//
//  PDFViewModel.swift
//  Biblio
//
//  Created by Joanna Owczarek on 14/09/2024.
//

import Foundation
import SwiftUI
import PDFKit

// MARK: - Chapter Model
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

// MARK: - ViewModel
class PDFViewModel: ObservableObject {
    @Published var chapters: [Chapter] = []
    @Published var selectedChapter: Chapter?
    @Published var url: URL?
    @Published var currentPage: Int = 1
    @Published var totalPages: Int = 1


    init(url: URL?) {
        self.url = url
        loadDocument()
    }
    
    func loadDocument() {
            guard let url = url else { return }
            guard let document = PDFDocument(url: url) else {
                print("Failed to load PDF document from URL: \(url)")
                return
            }
            extractChapters(document: document)
            totalPages = document.pageCount
    }
    
    private func extractChapters(document: PDFDocument) {
        if let extractedChapters = extractChaptersFromTOC(document: document) {
            chapters = extractedChapters
        } else {
            chapters = extractChaptersFromText(document: document)
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
