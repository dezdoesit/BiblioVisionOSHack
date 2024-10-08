//
//  ContentView.swift
//  Biblio
//
//  Created by dmoney on 9/13/24.
//

import SwiftUI
import UniformTypeIdentifiers

struct ContentView: View {
    @EnvironmentObject var bookStore: BookStore
    @State private var isFilePickerPresented = false
    @State private var searchText = ""
    @Environment(\.openWindow) private var openWindow
    @Environment(\.dismissWindow) private var dismissWindow

    var filteredBooks: [Book] {
        if searchText.isEmpty {
            return bookStore.books
        } else {
            return bookStore.books.filter { $0.name.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        VStack(spacing: 20) {
            // Navigation bar with title
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
                    ForEach(filteredBooks) { book in
                        BookCardView(book: book) {
                            openBookDetailWindow(book: book)
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
        .fileImporter(
            isPresented: $isFilePickerPresented,
            allowedContentTypes: [UTType.pdf, UTType.epub],
            allowsMultipleSelection: true
        ) { result in
            do {
                let fileURLs = try result.get()
                for fileURL in fileURLs {
                    bookStore.addBook(url: fileURL)
                }
            } catch {
                print("Error importing files: \(error)")
            }
        }
        .onAppear {
            if bookStore.books.isEmpty {
                bookStore.loadSampleBooks()
            }
        }
    }

    private func openBookDetailWindow(book: Book) {
        print("Opening window for book: \(book.id)")
        dismissWindow()
        openWindow(id: "bookDetail", value: book.id)
    }
}
#Preview(windowStyle: .automatic) {
    ContentView()
        .environment(AppModel())
}
