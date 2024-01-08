//
//  GameViewModel.swift
//  BingoAI
//
//  Created by Zachary Tao on 1/1/24.
//

import Foundation

class GameViewModel: ObservableObject {
    @Published var bingoGrid: [[BingoSlot]] = []
    @Published var isGameWon: Bool = false
    

    init(descriptions: [String]) {
        assert(descriptions.count == 25, "There must be exactly 25 descriptions.")
        setupGrid(with: descriptions)
    }

    private func setupGrid(with descriptions: [String]) {
        bingoGrid = (0..<5).map { row in
            (0..<5).map { col in
                BingoSlot(description: descriptions[row * 5 + col], isSelected: false)
            }
        }
    }

    func selectSlot(at row: Int, column: Int) {
        bingoGrid[row][column].isSelected.toggle()
        checkForBingo()
    }

    private func checkForBingo() {
        // Check for horizontal, vertical, and diagonal Bingo
        isGameWon = checkHorizontal() || checkVertical() || checkDiagonal()
    }

    private func checkHorizontal() -> Bool {
        for row in bingoGrid {
            if row.allSatisfy({ $0.isSelected }) {
                return true
            }
        }
        return false
    }

    private func checkVertical() -> Bool {
        for col in 0..<5 {
                var allSelected = true
                for row in 0..<5 {
                    if !bingoGrid[row][col].isSelected {
                        allSelected = false
                        break
                    }
                }
                if allSelected {
                    return true
                }
            }
            return false
    }

    private func checkDiagonal() -> Bool {
        // Top-left to bottom-right
           var diagonal1 = true
           // Top-right to bottom-left
           var diagonal2 = true

           for i in 0..<5 {
               if !bingoGrid[i][i].isSelected {
                   diagonal1 = false
               }
               if !bingoGrid[i][4 - i].isSelected {
                   diagonal2 = false
               }
           }

           return diagonal1 || diagonal2
    }
    
    func updateDescriptions(with newDescriptions: [String]) {
            assert(newDescriptions.count == 25, "There must be exactly 25 descriptions.")
            setupGrid(with: newDescriptions)
    }
}
