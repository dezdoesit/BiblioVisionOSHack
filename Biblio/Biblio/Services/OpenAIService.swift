//
//  OpenAIService.swift
//  Biblio
//
//  Created by Joanna Owczarek on 15/09/2024.
//

import Foundation
import OpenAI

struct OpenAIService {
    private let openAI = OpenAI(apiToken: Constants.openAIAPIKey)
    
    func generateImagePrompt(from passages: [String]) async throws -> String {
        let combinedPassages = passages.joined(separator: " ")
        
        let systemPrompt = """
        You are an AI specialized in analyzing textual descriptions and converting them into detailed, vivid prompts for Skybox AI to generate immersive 3D environments. Your task is to create a prompt based on the given passages from a book, focusing on the visual and spatial elements described.

        Follow these guidelines:
        1. Start with a brief, high-level description of the scene.
        2. Describe the main elements of the 3D environment (e.g., "towering mountains", "winding river", "ancient ruins").
        3. Specify lighting and atmosphere (e.g., "golden hour sunlight", "misty fog", "starry night sky").
        4. Mention key textures and materials (e.g., "weathered stone", "lush foliage", "reflective water surface").
        5. Include any important objects or characters, describing their position in the scene.
        6. End with mood or style keywords (e.g., "photorealistic", "fantastical", "foreboding", "tranquil").

        Ensure the prompt is cohesive and focuses on the most visually impactful elements from the passages.
        """
        
        let userPrompt = """
        Based on the following passages from a book, create a detailed prompt for Skybox AI:

        \(combinedPassages)

        Skybox AI Prompt:
        """
        
        let query = ChatQuery(
            messages: [
                .system(.init(content: systemPrompt)),
                .user(.init(content: .string(userPrompt)))
            ],
            model: .gpt4_o
        )
        
        let result = try await openAI.chats(query: query)
        print(result)
        
        guard let promptText = result.choices.first?.message.content?.string else {
            throw NSError(
                domain: "OpenAIService",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Failed to generate Skybox AI prompt"]
            )
        }
        
        return promptText
    }
}
