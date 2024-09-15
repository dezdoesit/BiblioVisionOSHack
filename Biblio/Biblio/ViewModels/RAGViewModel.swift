//
//  RAGViewModel.swift
//  Biblio
//
//  Created by Joanna Owczarek on 15/09/2024.
//

import Foundation
import SwiftUI

class RAGViewModel: ObservableObject {
    let langaugeService: LanguageProcessingService
    let openAISerivce: OpenAIService
    
    init(book: Book) {
        self.langaugeService = .init(bookUID: book.id)
        self.openAISerivce = .init()
    }
    
    func addNewPage(content page: String, pageIndex: Int) {
        langaugeService.processPage(page, pageIndex: pageIndex)
    }
    
    func generateImagePrompt(currentPage: Int) async throws -> String {
        let results = langaugeService.findRelevantPassages(currentPage: currentPage)
        let prompt = try await openAISerivce.generateImagePrompt(from: results)
        print(prompt)
        return prompt
    }
}
