//
//  GameViewModel.swift
//  BingoAI
//
//  Created by Zachary Tao on 1/1/24.
//

import Foundation


class GridViewModel: ObservableObject {
    @Published var bingoGrid: [BingoSlot] = []
    @Published var isBingoed = false
    @Published var size = 5
    @Published var isIntialized = false
    

    init(descriptions: [String]) {
        setupEmptyGrid(with: descriptions)
    }
    
    func setupEmptyGrid(with descriptions: [String]) {
        bingoGrid = descriptions.map{ BingoSlot(description: $0, isSelected: false)}
    }

    func setupGrid(with descriptions: [String]) {
        bingoGrid = descriptions.map{ BingoSlot(description: $0, isSelected: false)
        }
        isIntialized = true
    }
        
    func deselectAll(){
        for index in bingoGrid.indices {
                bingoGrid[index].isSelected = false
            }
        isBingoed = false
    }
    
    
    func shuffle(){
        bingoGrid.shuffle()
    }

    func selectSlot(_ item: BingoSlot) {
        if let index = bingoGrid.firstIndex(where: {$0.id == item.id}){
            bingoGrid[index].isSelected.toggle()
        }
    }

    func checkForBingo(){
            isBingoed = checkRowBingo() || checkColumnBingo() || checkDiagonalBingo()
        
    }
    
    private func checkRowBingo() -> Bool {
        for row in 0..<size {
            var rowMark = true
            for column in 0..<size {
                if !bingoGrid[row * size + column].isSelected {
                    rowMark = false
                    break
                }
            }
            if rowMark {
                return true
            }
        }
        return false
    }

    private func checkColumnBingo() -> Bool {
        for column in 0..<size {
            var columnMark = true
            for row in 0..<size {
                if !bingoGrid[row * size + column].isSelected {
                    columnMark = false
                    break
                }
            }
            if columnMark {
                return true
            }
        }
        return false
    }

    private func checkDiagonalBingo() -> Bool {
        var diag1Mark = true
        var diag2Mark = true
        for i in 0..<size {
            if !bingoGrid[i * size + i].isSelected {
                diag1Mark = false
            }
            if !bingoGrid[i * size + (size - 1 - i)].isSelected {
                diag2Mark = false
            }
        }
        return diag1Mark || diag2Mark
    }
    
    func updateDescriptions(with newDescriptions: [String]) {
            assert(newDescriptions.count == 25, "There must be exactly 25 descriptions.")
            setupGrid(with: newDescriptions)
    }
}
