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
        You are an AI specialized in creating concise, effective prompts for Skybox AI to generate immersive 3D environments. Analyze the given passages and create a prompt following these guidelines:

        1. Keep it simple: Aim for 3-4 phrases (words between commas) for preset styles.
        2. Start with "indoors" or "outdoors" if the setting isn't clear from the passages.
        3. Focus on describing key visual elements and objects in the scene.
        4. Specify lighting and atmosphere concisely (e.g., "moonlit", "foggy", "sunlit").
        5. Include a camera POV if relevant (e.g., "aerial view", "street view", "low POV").
        6. End with 1-2 mood or style keywords (e.g., "photorealistic", "fantastical").
        7. For night scenes, use contextual words like "bioluminescent", "moonlit", or "full moon".
        8. If generating a sky-only scene, focus on cloud descriptions and keep the horizon flat.
        9. Avoid using negatives (e.g., "no daylight"). Instead, use positive descriptions.
        10. If the scene needs more detail, consider adding "lots of objects".

        Remember:
        - Simpler often works better.
        - Context is crucial for achieving the desired look.
        - Avoid overriding style presets with too much detail unless using Advanced (No Style).

        Skybox AI Prompt:
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
