//
//  BookStore.swift
//  Biblio
//
//  Created by dmoney on 9/15/24.
//

import SwiftUI

class BookStore: ObservableObject {
    @Published var books: [Book] = []

    func loadSampleBooks() {
        let sampleFiles = [
            "sample1.pdf",
            "sample2.epub",
            "sample3.pdf",
            "sample4.epub",
            "sample5.pdf"
            
        ]
        
        print("Loaded \(books.count) sample books: \(books.map { $0.id })")

        for fileName in sampleFiles {
            if let url = Bundle.main.url(forResource: fileName, withExtension: nil) {
                do {
                    let bookmarkData = try url.bookmarkData(options: .minimalBookmark, includingResourceValuesForKeys: nil, relativeTo: nil)
                    let book = Book(bookmarkData: bookmarkData)
                    books.append(book)
                } catch {
                    print("Error creating bookmark for \(fileName): \(error)")
                }
            } else {
                print("Could not find \(fileName) in the app bundle")
            }
        }
    }
}
