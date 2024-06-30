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
            apiKey: ProcessInfo.processInfo.environment["OpenAIAPI"] ?? ""
        )
        openAI = OpenAI(config)
    }
    
    func generateBingoDescriptions(from prompt: String) {
        isFetching = true
        let refinedPrompt = """
            Directly generate 27 unique and concise descriptions of features, qualities or names of items or examples within the category of typically found in \(prompt). Each description should be suitable for inclusion in a bingo sheet square and consist of 1-3 words only. Think about what would a user like to have on a bingo sheet. Do not format the output as a list with numbers or bullets. Never include any list number title such as 1. or 2. For example, if user type "making new friends", generate a format similar to this. Always generate 27 different descriptions:
                        has brown eyes
                        has curly hair
                        can do 5 jumping jacks
                        has a pet
                       hugged a parent today
            """

        let chat = [ChatMessage(role: .user, content: refinedPrompt)]
        let chatParameters = ChatParameters(model: .chatGPTTurbo, messages: chat)
        
        Task {
            do {
                let chatCompletion = try await openAI.generateChatCompletion(parameters: chatParameters)
                if let message = chatCompletion.choices.first?.message {
                    let descriptions = processResponseIntoBingoDescriptionsFor5(message.content)
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

    private func processResponseIntoBingoDescriptionsFor5(_ response: String?) -> [String] {
        if let response = response {
            print(response)
            let descriptions = response.components(separatedBy: "\n").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            var adjustedDescriptions = descriptions

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
    
    
    private func processResponseIntoBingoDescriptionsFor4(_ response: String?) -> [String] {
        if let response = response {
            let descriptions = response.components(separatedBy: "\n").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            var adjustedDescriptions = descriptions

            if adjustedDescriptions.count > 16 {
                // If there are more than 25 elements, keep only the first 25
                adjustedDescriptions = Array(adjustedDescriptions.prefix(16))
            } else if adjustedDescriptions.count < 16 {
                // If there are fewer than 25 elements, append empty strings to make it 25
                adjustedDescriptions.append(contentsOf: Array(repeating: "", count: 16 - adjustedDescriptions.count))
            }
            // Now adjustedDescriptions has exactly 25 elements
            return adjustedDescriptions
        } else {
            var numbers = Set<Int>()
            while numbers.count < 16 {
                numbers.insert(Int.random(in: 0...100))
            }
            let randomList = Array(numbers)
            return randomList.map { String($0) }
        }
    }
    
    
}
