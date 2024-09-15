import SwiftUI

struct DocumentDetailView: View {
    @StateObject private var pdfViewModel: PDFViewModel
    @StateObject private var ragViewModel: RAGViewModel
    let book: Book

    @State private var currentPage: Int = 1
    @Environment(\.dismiss) private var dismiss

    init(book: Book) {
        self.book = book
        _pdfViewModel = StateObject(wrappedValue: PDFViewModel(url: book.fileURL))
        _ragViewModel = StateObject(wrappedValue: RAGViewModel(book: book))
    }

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    dismiss()
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                        Text("Back")
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .background(Color.white.opacity(0.1))
                    .cornerRadius(15)
                }
                .padding()
                Spacer()
            }

            switch book.type {
            case .pdf:
                PDFKitView(viewModel: pdfViewModel, currentPage: $currentPage)
                    .gesture(
                        DragGesture()
                            .onEnded { value in
                                if value.translation.width < 0 {
                                    // Swipe left
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        currentPage = min(currentPage + 1, pdfViewModel.totalPages)
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
                    .task(priority: .userInitiated) {
                        guard let document = pdfViewModel.document, let text = document.string else {
                            print("Failed")
                            return
                        }
                        ragViewModel.addNewPage(content: text)
                        
                        do {
                            let output = try await ragViewModel.generateImagePrompt()
                        } catch {
                            print("Bruha")
                        }
                    }
            case .epub:
                EPUBKitView(url: book.fileURL)
            case .other(_):
                Text("Unsupported file type")
            }
        }
        .navigationBarHidden(true)
        .gesture(
            DragGesture()
                .onEnded { gesture in
                    if gesture.translation.height > 50 {
                        dismiss()
                    }
                }
        )
    }
}
