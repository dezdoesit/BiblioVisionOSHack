//
//  PDFKitView.swift
//  Biblio
//
//  Created by Joanna Owczarek on 14/09/2024.
//

import Foundation
import SwiftUI
import PDFKit

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
