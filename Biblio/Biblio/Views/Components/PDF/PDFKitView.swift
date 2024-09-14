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
   @ObservedObject var viewModel: PDFViewModel
   
   func makeUIView(context: Context) -> PDFView {
       let pdfView = PDFView()
       pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
       loadDocument(pdfView: pdfView)
       return pdfView
   }
   
   func updateUIView(_ uiView: PDFView, context: Context) {
       if let chapter = viewModel.selectedChapter {
           goToPage(pdfView: uiView, pageNumber: chapter.page)
       }
   }
   
   private func loadDocument(pdfView: PDFView) {
       guard let url = viewModel.url else { return }
       guard let document = PDFDocument(url: url) else {
           print("Failed to load PDF document from URL: \(url)")
           return
       }
       pdfView.document = document
       pdfView.autoScales = true
       pdfView.displayMode = .singlePageContinuous
   }
   
   private func goToPage(pdfView: PDFView, pageNumber: Int) {
       guard let page = pdfView.document?.page(at: pageNumber - 1) else { return }
       pdfView.go(to: page)
   }
}
