//import SwiftUI
//import PDFKit
//
//struct PDFKitContainerView: View {
//    @ObservedObject private var viewModel: PDFViewModel
//    
//    var columnVisibility: NavigationSplitViewVisibility {
//        viewModel.chapters.isEmpty ? .detailOnly : .automatic
//    }
//    
//    init(url: URL?) {
//        _viewModel = ObservedObject(wrappedValue: PDFViewModel(url: url))
//    }
//    
//    var body: some View {
//        NavigationSplitView(columnVisibility: .constant(columnVisibility)) {
//            List(viewModel.chapters, id: \.self, selection: $viewModel.selectedChapter) { chapter in
//                Text(chapter.name)
//            }
//            .navigationTitle("Chapters")
//        } detail: {
//            PDFKitView(viewModel: viewModel, currentPage: $viewModel.currentPage).id(viewModel.url)
//        }
//    }
//}
