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
    
    func processBook(_ bookContent: String) {
        let sentences = splitIntoSentences(bookContent)
        
        for i in stride(from: 0, to: sentences.count, by: 3) {
            let end = min(i + 3, sentences.count)
            let passage = sentences[i..<end].joined(separator: " ")
            guard let embedding = embeddingModel.vector(for: passage) else {
                print("failed to get embedding")
                return
            }
            vectorDB.addDocument(text: passage, embedding: embedding)
        }
    }
    
    private func splitIntoSentences(_ text: String) -> [String] {
        let tokenizer = NLTokenizer(unit: .sentence)
        tokenizer.string = text
        return tokenizer.tokens(for: text.startIndex..<text.endIndex).map { String(text[$0]) }
    }
    
    func findRelevantPassages(for query: String =
        """
             Describe the visual elements of the current scene in detail, including:
             1. The physical setting (e.g., indoor/outdoor, urban/rural, specific location)
             2. Time of day and lighting conditions
             3. Colors, textures, and materials present
             4. Notable objects or landmarks
             5. Characters' appearances and positions
             6. Any atmospheric details (weather, mood, ambiance)
             Focus on concrete, visual details that would be important for creating an illustration or image of the scene.
        """
    ) -> [String] {
        guard let queryEmbedding = embeddingModel.vector(for: query) else { return [] }
        
        let results = vectorDB.search(query: queryEmbedding)
        print(results)
        return results.map { $0.text }
    }
    //MARK: Rank content closer to the user higher
    //MARK: TO DO Add a reranker
    //    private func rerank(results: [SearchResult], query: String) -> [SearchResult] {
    //        // Implement a more sophisticated re-ranking algorithm
    //        // This is a simple example using BM25
    //        let bm25 = BM25(k1: 1.5, b: 0.75)
    //        return bm25.rank(documents: results.map { $0.text }, query: query)
    //            .sorted { $0.score > $1.score }
    //            .map { SearchResult(text: $0.document, score: $0.score) }
    //    }
    
    //    private func semanticFilter(passages: [SearchResult], query: String) -> [SearchResult] {
    //        // Implement semantic filtering
    //        // This is a simple example using cosine similarity
    //        guard let queryEmbedding = embeddingModel.vector(for: query) else { return passages }
    //
    //        return passages.filter { passage in
    //            guard let passageEmbedding = embeddingModel.vector(for: passage.text) else { return false }
    //            let similarity = cosineSimilarity(queryEmbedding, passageEmbedding)
    //            return similarity > 0.7 // Adjust threshold as needed
    //        }
    //    }
    //
    //    private func cosineSimilarity(_ v1: [Float], _ v2: [Float]) -> Float {
    //        let dotProduct = zip(v1, v2).map(*).reduce(0, +)
    //        let magnitude1 = sqrt(v1.map { $0 * $0 }.reduce(0, +))
    //        let magnitude2 = sqrt(v2.map { $0 * $0 }.reduce(0, +))
    //        return dotProduct / (magnitude1 * magnitude2)
    //    }
}
