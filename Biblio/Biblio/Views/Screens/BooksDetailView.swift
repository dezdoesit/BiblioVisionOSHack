//
//  BooksDetailView.swift
//  Biblio
//
//  Created by dmoney on 9/15/24.
//

import SwiftUI

struct DocumentDetailView: View {
    let book: Book

    var body: some View {
        VStack {
            Text(book.name)
                .font(.title)

            switch book.type {
            case .pdf:
                Text("PDF Viewer goes here")
                // Implement your PDF viewer here
            case .epub:
                Text("EPUB Viewer goes here")
                // Implement your EPUB viewer here
            case .other:
                Text("Unsupported file type")
            }
        }
    }
}
