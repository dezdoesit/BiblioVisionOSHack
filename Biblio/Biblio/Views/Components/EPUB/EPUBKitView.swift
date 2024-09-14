//
//  EPUBKitView.swift
//  Biblio
//
//  Created by Joanna Owczarek on 14/09/2024.
//

import Foundation
import EPUBKit
import SwiftUI

struct EPUBKitView: View {
    @ObservedObject var viewModel: EPUBManager
    
    init(url: URL?) {
        self._viewModel = ObservedObject(wrappedValue: EPUBManager(url: url))
    }
    
    var body: some View {
        NavigationView {
            List(viewModel.chapterSpineItems, id: \.idref) { item in
                if let path = viewModel.getPath(idref: item.idref) {
                    Button(action: {
                        viewModel.loadChapter(from: path)
                    }) {
                        Text(viewModel.pathToLabelDic[path] ?? "Unknown")
                    }
                }
            }
            .navigationTitle(viewModel.document?.title ?? "Unknown")
            .navigationBarTitleDisplayMode(.inline)
            
            ChapterContentView(content: viewModel.currentChapter)
        }
    }
}
