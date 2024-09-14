import SwiftUI
import PDFKit
import QuickLook

import SwiftUI
import PDFKit

struct DocumentDetailView: View {
    let book: Book
    @State private var pdfView: PDFView?

    var body: some View {
        VStack {
            if book.type == "PDF" {
                PDFKitView(book: book)

            } else {
                Text("Unsupported file type")
            }
        }
    }
}


struct PDFKitView: UIViewRepresentable {
    let book: Book

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        if let url = book.fileURL {
            pdfView.document = PDFDocument(url: url)
        }
        pdfView.displayMode = .singlePageContinuous
        pdfView.autoScales = true
        pdfView.delegate = context.coordinator

        // Enable text selection
        pdfView.isUserInteractionEnabled = true

        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PDFViewDelegate {
        var parent: PDFKitView

        init(_ parent: PDFKitView) {
            self.parent = parent
        }

    }
}


struct QuickLookPreview: UIViewControllerRepresentable {
    let book: Book

    func makeUIViewController(context: Context) -> QLPreviewController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: QLPreviewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, QLPreviewControllerDataSource {
        let parent: QuickLookPreview

        init(_ parent: QuickLookPreview) {
            self.parent = parent
        }

        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1
        }

        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            guard let url = parent.book.fileURL else {
                fatalError("Expected a valid URL")
            }
            return url as QLPreviewItem
        }
    }
}
