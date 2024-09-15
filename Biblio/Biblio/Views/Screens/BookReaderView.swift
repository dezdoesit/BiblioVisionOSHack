//
//  BookReaderView.swift
//  Biblio
//
//  Created by dmoney on 9/15/24.
//

import SwiftUI

struct BookReaderView: View {
    let book: Book

    var body: some View {
        DocumentDetailView(book: book)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismissWindow(id: "BookReader")
                        openWindow(id: "ContentView")
                    }
                }
            }
    }
}
#Preview {
    BookReaderView()
}
