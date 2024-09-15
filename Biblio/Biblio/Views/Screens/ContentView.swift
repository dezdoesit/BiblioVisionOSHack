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
    @State private var selectedBook: Book?
    @State private var searchText = ""

    var body: some View {
        VStack(spacing: 20) {
            // Navigation bar with title and profile
            HStack {
                Text("Books")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            .padding(.all, 30)

            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding()
                TextField("Search", text: $searchText)
                    .font(.title3)
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(Color(.sRGB, red: 0.33, green: 0.33, blue: 0.33, opacity: 1))
                    }
                }
            }
            .background(Color.gray.opacity(0.2))
            .cornerRadius(40)
            .padding(.horizontal)


            // Horizontal scroll view for books
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 25) {
                    ForEach(books) { book in
                        BookCardView(book: book)
                            {
                                selectedBook = book
                            }
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 400)

            Spacer()

            // Add book button
            Button(action: {
                isFilePickerPresented = true
            }) {
                Label("Add Book", systemImage: "plus")
            }
            .padding()

        }
        .sheet(item: $selectedBook) { book in
            DocumentDetailView(book: book)
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
                print("Error importing files: \(error)")
            }
        }
        .onAppear {
            loadSampleBooks()
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
