//
//  GridView.swift
//  BingoAI
//
//  Created by Zachary Tao on 1/1/24.
//

import SwiftUI

struct GridView: View {
    @ObservedObject var viewModel: GameViewModel
    let columns = [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ]

    var body: some View {
        VStack {
            Spacer()
            LazyVGrid(columns: columns) {
                        ForEach(0..<25, id: \.self) { index in
                            let row = index / 5
                            let column = index % 5
                            BingoSlotView(slot: viewModel.bingoGrid[row][column])
                                .onTapGesture {
                                    viewModel.selectSlot(at: row, column: column)
                                }
                        }
                    }
            Spacer(minLength: 20)
            if viewModel.isGameWon {
                Text("Bingo!")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                    .padding(20)
                    .background(Color.green)
                    .cornerRadius(12)
                    .shadow(radius: 10)
            }else{
                Text("      ")
                    .font(.title)
                    .fontWeight(.heavy)
                    .padding(20)


            }
            Spacer()
        }
    }
}

struct BingoSlotView: View {
    var slot: BingoSlot
    
    var body: some View {
        Text(slot.description)
            .font(.system(size: 16))
            .fontWeight(slot.isSelected ? .medium : .regular)
            .minimumScaleFactor(0.7)
            .frame(width: 55, height: 80)
            .foregroundColor(slot.isSelected ? .green : .primary)
            .transition(.scale)
            .padding(6)
            .background(
                // Add a subtle gradient or solid color with a card-like feel
                LinearGradient(gradient: Gradient(colors: [Color.white, Color.blue.opacity(0.3)]), startPoint: .top, endPoint: .bottom)
                    .cornerRadius(10)
                    .frame(width: 70, height: 90)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(slot.isSelected ? Color.green : Color.gray, lineWidth: 2)
                    .frame(width: 70, height: 90)
                
                
            )
            .scaleEffect(slot.isSelected ? 1.06 : 1.0)
    }
}


struct BingoView_Previews: PreviewProvider {
    static var previews: some View {
        //        let descriptions = (1...25).map { "Item \($0)" }
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
        let viewModel = GameViewModel(descriptions: descriptions)
        return GridView(viewModel: viewModel)
    }
}
