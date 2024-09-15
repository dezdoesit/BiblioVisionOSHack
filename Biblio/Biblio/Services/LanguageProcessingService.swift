//
//  RAG.swift
//  Biblio
//
//  Created by Joanna Owczarek on 15/09/2024.
//

import Foundation
import NaturalLanguage
import SVDB

struct LanguageProcessingService {
    private let embeddingModel = NLEmbedding.sentenceEmbedding(for: .english)!
    private let vectorDB: Collection
    
    init(bookUID: UUID) {
        self.vectorDB = try! SVDB.shared.collection(bookUID.uuidString)
    }
    
    static let defaultSearchQuery = """
             Describe the visual elements of the current scene in detail, including:
             1. The physical setting (e.g., indoor/outdoor, urban/rural, specific location)
             2. Time of day and lighting conditions
             3. Colors, textures, and materials present
             4. Notable objects or landmarks
             6. Any atmospheric details (weather, mood, ambiance)
             Focus on concrete, visual details that would be important for creating an illustration or image of the scene.
        """
    
    
    func processPage(_ pageContent: String, pageIndex: Int, passageLength: Int = 5, overlapSize: Int = 1) {
        let sentences = splitIntoSentences(pageContent)
        for i in stride(from: 0, to: sentences.count, by: passageLength - overlapSize) {
            let end = min(i + passageLength, sentences.count)
            let passage = sentences[i..<end].joined(separator: " ")
            guard let embedding = embeddingModel.vector(for: passage) else {
                print("Failed to get embedding for passage")
                continue
            }
            let indexedPassage = "[\(pageIndex)] \(passage)"
            vectorDB.addDocument(text: indexedPassage, embedding: embedding)
        }
    }
    
    private func splitIntoSentences(_ text: String) -> [String] {
        let tokenizer = NLTokenizer(unit: .sentence)
        tokenizer.string = text
        return tokenizer.tokens(for: text.startIndex..<text.endIndex).map { range in
            let sentence = String(text[range])
            let cleanedSentence = sentence
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: "\\s+", with: " ")
           return cleanedSentence
        }
    }
    
    func findRelevantPassages(for query: String = defaultSearchQuery, currentPage: Int) -> [String] {
        let queryWithPage = "[\(currentPage)] \(query)"
        guard let queryEmbedding = embeddingModel.vector(for: queryWithPage) else { return [] }
        let results = vectorDB.search(query: queryEmbedding, num_results: 20)
        let output = rerank(results: results, currentPage: currentPage)
        let topResults = output.prefix(10).map { $0 }
        return topResults
    }
    
    private func rerank(results: [SearchResult], currentPage: Int) -> [String] {
        let scoredResults = results.map { result -> (text: String, score: Double) in
            let pageMatch = extractPageNumber(from: result.text)
            let distance = abs(currentPage - pageMatch)
            let proximityScore = 1.0 / (1.0 + Float(distance))
            
            let weightSearch = 0.8
            let weightProximity = 0.2
            let combinedScore = (result.score * weightSearch) + (Double(proximityScore) * weightProximity)
            return (result.text, combinedScore)
        }
        
        return scoredResults.sorted { $0.score > $1.score }.map {
            let cleanedText = removePageIndex(from: $0.text)
            return cleanedText
        }
    }
    
    private func removePageIndex(from text: String) -> String {
       let pattern = "\\[\\d+\\]\\s*"
       let regex = try! NSRegularExpression(pattern: pattern)
       return regex.stringByReplacingMatches(in: text, range: NSRange(location: 0, length: text.utf16.count), withTemplate: "")
    }

    private func extractPageNumber(from text: String) -> Int {
       let pattern = "\\[(\\d+)\\]"
       let regex = try! NSRegularExpression(pattern: pattern)
       let nsString = text as NSString
       let results = regex.matches(in: text, range: NSRange(location: 0, length: nsString.length))
       if let match = results.first {
           let pageNumberString = nsString.substring(with: match.range(at: 1))
           return Int(pageNumberString) ?? 0
       }
       return 0
    }
}
