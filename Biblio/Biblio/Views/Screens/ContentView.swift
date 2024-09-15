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
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
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

struct BookCardView: View {
    let book: Book
    let onTap: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let coverImage = book.coverImage {
                Image(uiImage: coverImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 150)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 200, height: 150)
                    .cornerRadius(12)
                    .overlay(
                        Image(systemName: book.type.iconName)
                            .foregroundColor(book.type.iconColor)
                            .font(.largeTitle)
                    )
            }


            Text(book.name)
                .font(.headline)


            Text("Author")
                .font(.caption)


            Button(action: onTap) {
                Label("Read Book", systemImage: "book")

            }
            .padding()



        }
        .frame(width: 200, height: 300)
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(8)

    }

}

#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
