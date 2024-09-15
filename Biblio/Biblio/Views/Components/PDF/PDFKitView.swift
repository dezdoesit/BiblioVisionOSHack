////
////  PDFKitView.swift
////  Biblio
////
////  Created by Joanna Owczarek on 14/09/2024.
////
//
//import Foundation
//import SwiftUI
//import PDFKit
//
//struct PDFKitView: UIViewRepresentable {
//    @ObservedObject var viewModel: PDFViewModel
//    @Binding var currentPage: Int
//
//    func makeUIView(context: Context) -> PDFView {
//        let pdfView = PDFView()
//        pdfView.displayMode = .twoUp
//        pdfView.displaysAsBook = true
//        pdfView.autoScales = true
//        pdfView.displayDirection = .horizontal
//        pdfView.usePageViewController(true, withViewOptions: [UIPageViewController.OptionsKey.interPageSpacing: 20])
//        pdfView.delegate = context.coordinator
//
//        loadDocument(pdfView: pdfView)
//        return pdfView
//    }
//
//    func updateUIView(_ uiView: PDFView, context: Context) {
//        if let document = uiView.document, currentPage != document.index(for: uiView.currentPage!) + 1 {
//            if let page = document.page(at: currentPage - 1) {
//                uiView.go(to: page)
//            }
//        }
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    private func loadDocument(pdfView: PDFView) {
//        guard let url = viewModel.url else { return }
//        guard let document = PDFDocument(url: url) else {
//            print("Failed to load PDF document from URL: \(url)")
//            return
//        }
//        pdfView.document = document
//    }
//
//    class Coordinator: NSObject, PDFViewDelegate {
//        var parent: PDFKitView
//
//        init(_ parent: PDFKitView) {
//            self.parent = parent
//        }
//
//        func pdfViewPageChanged(_ pdfView: PDFView) {
//            if let currentPage = pdfView.currentPage, let document = pdfView.document {
//                parent.currentPage = document.index(for: currentPage) + 1
//            }
//        }
//    }
//}
