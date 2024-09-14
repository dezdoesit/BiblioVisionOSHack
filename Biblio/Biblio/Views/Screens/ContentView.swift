//
//  ContentView.swift
//  Biblio
//
//  Created by dmoney on 9/13/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @State var books: [Book] = []
    @State private var isFilePickerPresented = false

    var body: some View {
        NavigationSplitView {
            List(books) { book in
                NavigationLink(destination: DocumentDetailView(book: book)) {
                    DocumentRow(document: book)
                }
            }
            .navigationTitle("Books")
            .toolbar {
                Button(action: {
                    isFilePickerPresented = true
                }) {
                    Image(systemName: "plus")
                }
            }
        } detail: {
            Text("Select a document")
        }
        .onAppear(){
            loadSampleBooks()
        }
        .fileImporter(
            isPresented: $isFilePickerPresented,
            allowedContentTypes: [UTType.pdf, UTType.epub],
            allowsMultipleSelection: true
        ) { result in
            do {
                let fileURLs = try result.get()
                for fileURL in fileURLs {
                    let bookmarkData = try fileURL.bookmarkData(options: .minimalBookmark, includingResourceValuesForKeys: nil, relativeTo: nil)
                    let book = Book(bookmarkData: bookmarkData)
                    books.append(book)
                }
            } catch {
                print("Error importing files: \(error.localizedDescription)")
            }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
