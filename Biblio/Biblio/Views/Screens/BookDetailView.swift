import SwiftUI
import PDFKit



struct DocumentDetailView: View {
    @StateObject private var ragViewModel: RAGViewModel
    @ObservedObject private var viewModel: BookDetailViewModel
    let book: Book

    init(book: Book) {
        self.book = book
        _viewModel = ObservedObject(wrappedValue: BookDetailViewModel(book: book))
        _ragViewModel = StateObject(wrappedValue: RAGViewModel(book: book))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let content = viewModel.content {
                    Text(content)
                        .font(.body)
                        .lineSpacing(8)
                        .padding(.horizontal)
                } else {
                    ProgressView("Loading content...")
                }
            }
        }
        .navigationTitle(viewModel.title ?? "Book")
    }
}

