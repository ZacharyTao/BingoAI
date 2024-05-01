//
//  GridView.swift
//  BingoAI
//
//  Created by Zachary Tao on 1/1/24.
//

import SwiftUI



struct GridView: View {
    @ObservedObject var viewModel: GridViewModel
    @State private var draggingItem: String?

    @State private var isInitialized = false
    
    var body: some View {
        VStack(spacing: 0){
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: viewModel.size), spacing: 0) {
                
                let totalIndex = Int(pow(Double(viewModel.size), 2.0))
                let modifedGridItem = Array( viewModel.bingoGrid.prefix(totalIndex))
                
                ForEach(Array(modifedGridItem.enumerated()), id: \.element.id) { index, _ in
                    if totalIndex == 25, index == 12{
                        BingoFreeSlotView(slot: viewModel.bingoGrid[index])
                            .environmentObject(viewModel)
                            .aspectRatio(viewModel.size == 5 ? 0.85 : 1, contentMode: .fit)
                            .onTapGesture {
                                viewModel.selectSlot(viewModel.bingoGrid[index])
                                viewModel.checkForBingo()
                            }
                            .padding(3)

                    }else{
                        BingoSlotView(slot: viewModel.bingoGrid[index])
                            .aspectRatio(viewModel.size == 5 ? 0.85 : 1, contentMode: .fit)
                            .onTapGesture {
                                viewModel.selectSlot(viewModel.bingoGrid[index])
                                viewModel.checkForBingo()
                            }
                            .draggable(viewModel.bingoGrid[index].description){
                                Color.clear
                                    .onAppear {
                                        draggingItem = viewModel.bingoGrid[index].description
                                    }
                            }
                            .dropDestination(for: String.self){_, location in
                                draggingItem = nil
                                return false
                            } isTargeted: { status in
                                if let draggingItem, status, draggingItem != viewModel.bingoGrid[index].description{
                                    if let sourceIndex = viewModel.bingoGrid.firstIndex(where: {$0.description == draggingItem}),
                                       let destinationIndex = viewModel.bingoGrid.firstIndex(where: {$0.description == viewModel.bingoGrid[index].description}){
                                        withAnimation{
                                            let sourceItem = viewModel.bingoGrid.remove(at: sourceIndex)
                                            viewModel.bingoGrid.insert(sourceItem, at: destinationIndex)
                                        }
                                        
                                    }
                                }
                                
                            }
                            .padding(3)
                        
                    }
                }

                
            }    .animation(.default, value: viewModel.bingoGrid)


        }
    }
}


struct BingoFreeSlotView: View {
    @EnvironmentObject var viewModel: GridViewModel
    var slot: BingoSlot
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(
                LinearGradient(gradient: Gradient(colors: [Color.white, Color.blue.opacity(0.3)]), startPoint: .top, endPoint: .bottom)
            )
            .stroke(slot.isSelected ? Color.green : Color.gray, lineWidth: 2)
        
            .overlay{
                
                Text(!viewModel.isIntialized ? " " : "FREE!")
                    .font(.caption)
                    .fontWeight(.regular)
                    .minimumScaleFactor(0.6)
                    .foregroundColor(slot.isSelected ? .green : .primary)
                    .padding(5)
            }
    }
}

struct BingoSlotView: View {
    var slot: BingoSlot
    
    var body: some View {
        RoundedRectangle(cornerRadius: 5)
            .fill(
                LinearGradient(gradient: Gradient(colors: [Color.white, Color.blue.opacity(0.3)]), startPoint: .top, endPoint: .bottom)
            )
            .stroke(slot.isSelected ? Color.green : Color.gray, lineWidth: 2)
        
            .overlay{
                Text(slot.description)
                    .font(.caption)
                    .fontWeight(.regular)
                    .minimumScaleFactor(0.6)
                    .foregroundColor(slot.isSelected ? .green : .primary)
                    .padding(5)
            }
    }
}


struct BingoView_Previews: PreviewProvider {
    static var previews: some View {
        let descriptions: [String] = [
            "has brown eyes",
            "has curly hair",
            "can do 5 jumping jacks",
            "can say \"hello\" in a language other than English",
            "has a little brother or sister",
            "has lived in two different places",
            "read a book today",
            "can stand on one foot for 30 seconds",
            "has a pet",
            "ate something sweet for breakfast",
            "hugged a parent today",
            "has tried something new this week",
            "free!",
            "is excited to go to school this fall",
            "has blue eyes",
            "is wearing something red",
            "can sing a song",
            "visited another state",
            "can rollerskate, ice skate, or ride a bike",
            "has an older sister or brother",
            "can make a funny animal sound",
            "knows a super-silly joke",
            "watched a movie this month",
            "knows how to make a snack",
            "has a cousin"
        ]
        let viewModel = GridViewModel(descriptions: descriptions)
        return GridView(viewModel: viewModel)
    }
}
