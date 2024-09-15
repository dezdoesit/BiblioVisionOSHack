//
//  RAG.swift
//  Biblio
//
//  Created by Joanna Owczarek on 15/09/2024.
//

import Foundation
//
//  rag.swift
//  Biblio
//
//  Created by Joanna Owczarek on 14/09/2024.
//

import Foundation
import Foundation
import NaturalLanguage
import SVDB
import PDFKit

class RAGBookImageGenerator {
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
    
    private func findRelevantPassages(for query: String) -> [String] {
        guard let queryEmbedding = embeddingModel.vector(for: query) else { return [] }
        
        let results = vectorDB.search(query: queryEmbedding)
        print(results)
        return results.map { $0.text }
    }
    
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
    
    
    func generateImagePrompt(bookContent: String) {
        processBook(bookContent)
        let query = """
          Describe the visual elements of the current scene in detail, including:
          1. The physical setting (e.g., indoor/outdoor, urban/rural, specific location)
          2. Time of day and lighting conditions
          3. Colors, textures, and materials present
          4. Notable objects or landmarks
          5. Characters' appearances and positions
          6. Any atmospheric details (weather, mood, ambiance)
          Focus on concrete, visual details that would be important for creating an illustration or image of the scene.
          """
        let results = findRelevantPassages(for: query)
        
        
    }
    
    
//    func generateImagePrompt(forPage currentPage: Int, in book: Book) async throws -> String {
//        let currentContent = try book.getContent(upToPage: currentPage)
//        let query = "Describe the current scene and environment in this part of the book"
//        let relevantPassages = findRelevantPassages(for: query, in: currentContent)
////        return try await createImagePrompt(from: relevantPassages)
//        return revevant
//    }
    
  
    
    
    
//    private func createImagePrompt(from passages: [String]) async throws -> String {
//        let prompt = """
//        Based on the following passages from a book, create a detailed prompt for image generation.
//        Focus on visual elements, colors, lighting, and atmosphere. The prompt should describe a cohesive scene
//        that captures the essence of these passages:
//
//        \(passages.joined(separator: "\n\n"))
//
//        Image Generation Prompt:
//        """
//
//        let requestBody: [String: Any] = [
//            "model": "gpt-3.5-turbo",
//            "messages": [
//                ["role": "system", "content": "You are a helpful assistant that creates detailed image generation prompts based on book passages."],
//                ["role": "user", "content": prompt]
//            ],
//            "temperature": 0.7,
//            "max_tokens": 200
//        ]
//
//        var request = URLRequest(url: openAIEndpoint)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.setValue("Bearer \(openAIKey)", forHTTPHeaderField: "Authorization")
//        request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
//
//        let (data, _) = try await URLSession.shared.data(for: request)
//        let response = try JSONDecoder().decode(ChatGPTResponse.self, from: data)
//
//        guard let content = response.choices.first?.message.content else {
//            throw NSError(domain: "RAGBookImageGenerator", code: 2, userInfo: [NSLocalizedDescriptionKey: "No content in response"])
//        }
//
//        return content.trimmingCharacters(in: .whitespacesAndNewlines)
//    }
}

//struct ChatGPTResponse: Codable {
//    struct Choice: Codable {
//        struct Message: Codable {
//            let content: String
//        }
//        let message: Message
//    }
//    let choices: [Choice]
//}

// Usage example
//class BookImageApp {
//    let generator: RAGBookImageGenerator
//    let imageAPI: ImageGenerationAPI
//
//    init(openAIKey: String, imageAPIKey: String) {
//        self.generator = RAGBookImageGenerator(openAIKey: openAIKey)
//        self.imageAPI = ImageGenerationAPI(apiKey: imageAPIKey)
//    }
//
//    func processBook(_ book: Book) {
//        generator.processBook(book)
//    }
//
//    func generateImage(forPage currentPage: Int, in book: Book) async throws -> UIImage {
//        let prompt = try await generator.generateImagePrompt(forPage: currentPage, in: book)
//        return try await imageAPI.generateImage(fromPrompt: prompt)
//    }
//}
//
//// Assuming you have an ImageGenerationAPI class that handles image generation
//class ImageGenerationAPI {
//    // Implementation details...
//    func generateImage(fromPrompt prompt: String) async throws -> UIImage {
//        // API call to generate image...
//    }
//}

//// Example usage
//let app = BookImageApp(openAIKey: "your-openai-key", imageAPIKey: "your-image-api-key")
//let book = Book() // Your book object
//
//Task {
//    do {
//        app.processBook(book)
//        let currentPage = 100
//        let image = try await app.generateImage(forPage: currentPage, in: book)
//        // Display or save the generated image
//    } catch {
//        print("Error generating image: \(error)")
//    }
//}
