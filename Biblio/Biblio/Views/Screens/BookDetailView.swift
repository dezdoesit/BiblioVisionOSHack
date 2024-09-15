import SwiftUI

struct DocumentDetailView: View {
    @StateObject private var ragViewModel: RAGViewModel
    @ObservedObject private var viewModel: BookDetailViewModel
    let book: Book

    @State private var currentPage: Int = 1
    @Environment(\.dismiss) private var dismiss

    init(book: Book) {
        self.book = book
        _viewModel = ObservedObject(wrappedValue: BookDetailViewModel(book: book))
        _ragViewModel = StateObject(wrappedValue: RAGViewModel(book: book))
    }

    var body: some View {
        NavigationView {
            if viewModel.content != nil {
                ScrollView {
                    Text(viewModel.content!)
                        .multilineTextAlignment(.leading)
                }
            } else {
                ProgressView("loading")
            }
        }
        .navigationTitle(viewModel.title ?? "Loading")
//        .navi
//        VStack {
//            HStack {
//                Button(action: {
//                    dismiss()
//                }) {
//                    HStack {
//                        Image(systemName: "chevron.left")
//                            .foregroundColor(.blue)
//                        Text("Back")
//                            .foregroundColor(.blue)
//                    }
//                    .padding()
//                    .background(Color.white.opacity(0.1))
//                    .cornerRadius(15)
//                }
//                .padding()
//                Spacer()
//            }
            
           

//            switch book.type {
//            case .pdf:
//                PDFKitView(viewModel: pdfViewModel, currentPage: $currentPage)
//                    .gesture(
//                        DragGesture()
//                            .onEnded { value in
//                                if value.translation.width < 0 {
//                                    // Swipe left
//                                    withAnimation(.easeInOut(duration: 0.3)) {
//                                        currentPage = min(currentPage + 1, pdfViewModel.totalPages)
//                                    }
//                                } else if value.translation.width > 0 {
//                                    // Swipe right
//                                    withAnimation(.easeInOut(duration: 0.3)) {
//                                        currentPage = max(currentPage - 1, 1)
//                                    }
//                                }
//                            }
//                    )
//                    .transition(.asymmetric(
//                        insertion: .move(edge: .trailing).combined(with: .opacity),
//                        removal: .move(edge: .leading).combined(with: .opacity)
//                    ))
//                    .task(priority: .userInitiated) {
//                        guard let document = pdfViewModel.document else {
//                            print("Failed")
//                            return
//                        }
//                        let pageCount = document.pageCount
//
//                        for i in 0 ..< pageCount {
//                            guard let page = document.page(at: i) else { continue }
//                            guard let pageContent = page.string else { continue }
//                            ragViewModel.addNewPage(content: pageContent, pageIndex: i)
//                        }
//                        
//                        do {
//                            let output = try await ragViewModel.generateImagePrompt(currentPage: pageCount-1)
//                        } catch {
//                            print("Bruha")
//                        }
//                    }
//            case .epub:
//                EPUBKitView(url: book.fileURL)
//            case .other(_):
//                Text("Unsupported file type")
//            }
        }
//        .gesture(
//            DragGesture()
//                .onEnded { gesture in
//                    if gesture.translation.height > 50 {
//                        dismiss()
//                    }
//                }
//        )
//    }
}
