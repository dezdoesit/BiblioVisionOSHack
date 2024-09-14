import SwiftUI

struct DocumentDetailView: View {
    let book: Book

    var body: some View {
        VStack {
            switch book.type {
            case .pdf:
                PDFKitContainerView(url: book.fileURL)
            case .epub:
                EPUBKitView(url: book.fileURL)
            case .other(_):
                Text("Unsupported file type")
            }
        }
    }
}

////MARK: NOT sure what this is meant for
//struct QuickLookPreview: UIViewControllerRepresentable {
//    let book: Book
//
//    func makeUIViewController(context: Context) -> QLPreviewController {
//        let controller = QLPreviewController()
//        controller.dataSource = context.coordinator
//        return controller
//    }
//
//    func updateUIViewController(_ uiViewController: QLPreviewController, context: Context) {}
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, QLPreviewControllerDataSource {
//        let parent: QuickLookPreview
//
//        init(_ parent: QuickLookPreview) {
//            self.parent = parent
//        }
//
//        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
//            return 1
//        }
//
//        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
//            guard let url = parent.book.fileURL else {
//                fatalError("Expected a valid URL")
//            }
//            return url as QLPreviewItem
//        }
//    }
//}
//
