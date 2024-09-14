import SwiftUI
import PDFKit
import QuickLook

struct DocumentDetailView: View {
    let document: Document

    var body: some View {
        if document.type == "PDF" {
            PDFKitView(document: document)
        } else {
            QuickLookPreview(document: document)
        }
    }
}
struct PDFKitView: UIViewRepresentable {
    let document: Document

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        if let url = document.fileURL {
            if url.startAccessingSecurityScopedResource() {
                defer { url.stopAccessingSecurityScopedResource() }
                pdfView.document = PDFDocument(url: url)
            }
        }
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {}
}

struct QuickLookPreview: UIViewControllerRepresentable {
    let document: Document

    func makeUIViewController(context: Context) -> QLPreviewController {
        let controller = QLPreviewController()
        controller.dataSource = context.coordinator
        return controller
    }

    func updateUIViewController(_ uiViewController: QLPreviewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, QLPreviewControllerDataSource {
        let parent: QuickLookPreview

        init(parent: QuickLookPreview) {
            self.parent = parent
        }

        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1
        }

        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            return parent.document.fileURL as QLPreviewItem? ?? NSURL()
        }
    }
}
