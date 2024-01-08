//
//  ContentView.swift
//  BingoAI
//
//  Created by Zachary Tao on 12/31/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = BingoViewModel()
    @State private var prompt: String = ""
    
    var body: some View {
        NavigationView{
            GeometryReader { _ in
                VStack {
                    HStack{
                        
                        TextField("Type in the prompt", text: $prompt)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        Button("Generate"){
                            
                            viewModel.generateBingoDescriptions(from: prompt)
                            
                        }
                        .disabled(prompt.isEmpty)
                        .buttonStyle(PrimaryButtonStyle())
                        
                    }
                    .padding()
                    
                    Spacer()
                    
                    if viewModel.isFetching {
                        VStack {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            Text("Generating...")
                                .foregroundColor(.secondary)
                        }
                    } else {
                        GridView(viewModel: GameViewModel(descriptions: viewModel.bingoDescriptions))
                            .padding(5)
                        Spacer()
                    }
                    Spacer()
                    
                    
                }
                .ignoresSafeArea(.keyboard, edges: .bottom)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { // <2>
                ToolbarItem(placement: .principal) { // <3>
                    Text("Welcome to BingoAI!").font(.title2).fontWeight(.semibold)
                    
                }
            }
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .frame(width: 110, height: 40)
            .background(configuration.isPressed ? Color.blue.opacity(0.5) : Color.blue)
            .clipShape(Capsule())
            .padding(.top, 8)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
