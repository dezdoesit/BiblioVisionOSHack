import SwiftUI

struct BookDetailWindow: View {
    @Environment(\.dismissWindow) private var dismissWindow
    @Environment(\.bookID) private var bookID
    @EnvironmentObject var bookStore: BookStore

    var body: some View {
        Group {
            if let bookID = bookID {
                if let book = bookStore.books.first(where: { $0.id == bookID }) {
                    DocumentDetailView(book: book)
                        .toolbar {
                            ToolbarItem(placement: .automatic) {
                                Button("Close") {
                                    dismissWindow(id: "bookDetail")
                                }
                            }
                        }
                } else {
                    Text("Book not found for ID: \(bookID)")
                }
            } else {
                Text("No book ID received")
            }
        }
        .onAppear {
            print("BookDetailWindow appeared with bookID: \(String(describing: bookID))")
            print("Available books: \(bookStore.books.map { $0.id })")
        }
    }
}
