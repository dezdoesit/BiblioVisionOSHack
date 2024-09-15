//
//  SampleBooks.swift
//  Biblio
//
//  Created by dmoney on 9/14/24.
//

import Foundation

extension ContentView {
    func loadSampleBooks() {
        let sampleFiles = [
            "sample1.pdf",
            "sample2.epub",
            "sample3.pdf",
            "sample4.epub",
            "sample5.pdf"
        ]

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
