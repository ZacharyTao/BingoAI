//
//  ViewModel.swift
//  BingoAI
//
//  Created by Zachary Tao on 1/1/24.
//

import Foundation
import OpenAIKit

class BingoViewModel: ObservableObject {
    @Published var bingoDescriptions: [String] = Array(repeating: "", count: 25)
    @Published var isFetching: Bool = false
    private var openAI: OpenAI
    
    init() {
        let config = Configuration(
            organizationId: "INSERT-ORGANIZATION-ID",
            apiKey: ProcessInfo.processInfo.environment["OpenAIAPI"] ?? "DefaultApiKey"
        )
        openAI = OpenAI(config)
        
    }
    
    func generateBingoDescriptions(from prompt: String) {
        isFetching = true
        
        let refinedPrompt = """
            Generate 24 unique and creative descriptions or words of features or qualities that one would find in \(prompt). Each description should be concise and suitable for a bingo sheet square, and should be 1-3 words. Never include any list number title such as 1. or 2. For example, if user type "making new friends", generate a format similar to this:
            
            has brown eyes
            has curly hair
            can do 5 jumping jacks
            can say "hello" in a language other than English
            has a little brother or sister
            has lived in two different places
            read a book today
            can stand on one foot for 30 seconds
            has a pet
            hugged a parent today
            has tried something new this week
            Free!
            is excited to go to school this fall
            has blue eyes
            is wearing something red
            can sing a song
            visited another state
            can rollerskate, ice skate, or ride a bike
            has an older sister or brother
            can make a funny animal sound
            knows a super-silly joke
            watched a movie this month
            knows how to make a snack
            has a cousin
            """

        let chat = [ChatMessage(role: .user, content: refinedPrompt)]
        let chatParameters = ChatParameters(model: .chatGPTTurbo, messages: chat)
        
        Task {
            do {
                let chatCompletion = try await openAI.generateChatCompletion(parameters: chatParameters)
                
                if let message = chatCompletion.choices.first?.message {
                    // For simplicity, returns an array of strings.
                    let descriptions = processResponseIntoBingoDescriptions(message.content)
                    DispatchQueue.main.async {
                        self.bingoDescriptions = descriptions
                        self.isFetching = false
                    }
                }
            } catch {
                print("Error: \(error)")
                DispatchQueue.main.async {
                    self.isFetching = false
                }
            }
        }
    }

    private func processResponseIntoBingoDescriptions(_ response: String?) -> [String] {
        if let response = response {
//            let descriptions = response.components(separatedBy: "\n")
//                return descriptions.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            let descriptions = response.components(separatedBy: "\n").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            var adjustedDescriptions = descriptions
            adjustedDescriptions.insert("Free!", at: 12)

            // Check if the array has less than 25 elements
            if adjustedDescriptions.count > 25 {
                // If there are more than 25 elements, keep only the first 25
                adjustedDescriptions = Array(adjustedDescriptions.prefix(25))
            } else if adjustedDescriptions.count < 25 {
                // If there are fewer than 25 elements, append empty strings to make it 25
                adjustedDescriptions.append(contentsOf: Array(repeating: "", count: 25 - adjustedDescriptions.count))
            }


            // Now adjustedDescriptions has exactly 25 elements
            return adjustedDescriptions
        } else {
            var numbers = Set<Int>()
            while numbers.count < 25 {
                numbers.insert(Int.random(in: 0...100))
            }
            let randomList = Array(numbers)
            return randomList.map { String($0) }
        }
    }
    
    
}
