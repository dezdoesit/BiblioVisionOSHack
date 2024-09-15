import SwiftUI
import PDFKit

struct DocumentDetailView: View {
    @Environment(\.dismissWindow) private var dismissWindow
    @ObservedObject private var viewModel: BookDetailViewModel

    init(book: Book) {
        _viewModel = ObservedObject(wrappedValue: BookDetailViewModel(book: book))
    }
    
    var columnVisibilty: NavigationSplitViewVisibility {
        return viewModel.chapters.count > 1 ? .automatic : .detailOnly
    }

    var body: some View {
        NavigationSplitView(columnVisibility: .constant(columnVisibilty)) {
            List(viewModel.chapters, id: \.self) { chapter in
                Text(chapter)
            }
        } detail: {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if let content = viewModel.content {
                        Text(content)
                            .font(.body)
                            .lineSpacing(8)
                            .padding(.horizontal)
                            .multilineTextAlignment(.leading)
                    } else {
                        ProgressView("Loading content...")
                    }
                }
            }
            .navigationTitle(viewModel.title ?? "Book")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismissWindow(id: "bookDetail")
                    }
                }
            }
        }

    }
}

