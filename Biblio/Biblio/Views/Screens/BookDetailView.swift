import SwiftUI

struct DocumentDetailView: View {
    let book: Book
    @StateObject private var viewModel: PDFViewModel
    @State private var currentPage: Int = 1

    init(book: Book) {
        self.book = book
        _viewModel = StateObject(wrappedValue: PDFViewModel(url: book.fileURL))
    }

    var body: some View {
        VStack {
            switch book.type {
            case .pdf:
                PDFKitView(viewModel: viewModel, currentPage: $currentPage)
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                if value.translation.width < 0 {
                                    // Swipe left
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        currentPage = min(currentPage + 1, viewModel.totalPages)
                                    }
                                } else if value.translation.width > 0 {
                                    // Swipe right
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        currentPage = max(currentPage - 1, 1)
                                    }
                                }
                            }
                    )
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))

            case .epub:
                EPUBKitView(url: book.fileURL)
            case .other(_):
                Text("Unsupported file type")
            }
        }
        .navigationTitle(book.name)
    }
}
