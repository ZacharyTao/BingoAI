//
//  ContentView.swift
//  BingoAI
//
//  Created by Zachary Tao on 12/31/23.
//

import SwiftUI
import Vortex

class UserSettings: ObservableObject{
    @Published var gridType: GridType = .five
    @Published var bgColor = Color.white
    @Published var gridColor = Color.white
    static var shared = UserSettings()
}

struct ContentView: View {
    @StateObject private var gptViewModel = BingoViewModel()
    @StateObject private var gridViewModel = GridViewModel(descriptions: Array(repeating: " ", count: 25))
    @StateObject private var userSettings = UserSettings.shared
    @State private var prompt: String = ""
    @State var showSettingSheet = false
    
    
    var body: some View {
        NavigationStack{
            VortexViewReader { proxy in

                ZStack(alignment: .top){
                    
                    VortexView(.confetti) {
                        Text("Bingo")
                            .foregroundStyle(.white)
                            .font(.largeTitle)
                            .tag("square")
                        
                        Circle()
                            .fill(.white)
                            .frame(width: 16)
                            .tag("circle")
                    }.ignoresSafeArea()
                    
                    GeometryReader{reader in
                        
                        VStack {
                            if gptViewModel.isFetching {
                                bingoProgressView
                            } else {
                                VStack(spacing: 0){
                                    promptTitleView
                                    GridView(viewModel: gridViewModel)
                                        .padding(5)
                                    buttonView
                                    Button{
                                        proxy.burst()
                                        proxy.move(to: CGPoint(x: reader.size.width / 2, y: 180))
                                        
                                    }label:{
                                        RoundedRectangle(cornerRadius: 20)
                                            .foregroundStyle(gridViewModel.isBingoed ? .green : .clear)
                                            .frame(width: 200, height: 100)
                                            .overlay{
                                                Text("Bingo!")
                                                    .font(.system(size: 40))
                                                    .fontWeight(.heavy)
                                                    .foregroundColor(gridViewModel.isBingoed ? .white : .clear)
                                            }
                                            .padding()
                                    }.disabled(!gridViewModel.isBingoed)
                                    
                                }
                                Spacer()
                            }
                        }
                        .onChange(of: userSettings.gridType){
                            switch userSettings.gridType {
                            case .four:
                                gridViewModel.size = 4
                                gridViewModel.checkForBingo()
                            case .five:
                                gridViewModel.size = 5
                                gridViewModel.checkForBingo()
                            }
                        }
                        .sheet(isPresented: $showSettingSheet){
                            SheetView()
                        }
                        .onChange(of: gridViewModel.isBingoed){
                            if gridViewModel.isBingoed{
                                proxy.burst()
                                proxy.move(to: CGPoint(x: reader.size.width / 2, y: 180))
                            }
                        }
                    }
                    }
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                    .onChange(of: gptViewModel.isFetching){
                        gridViewModel.setupGrid(with: gptViewModel.bingoDescriptions)
                    }
                   
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Text("Welcome to BingoAI!").font(.title2).fontWeight(.semibold)
                            
                        }
                        ToolbarItem(placement: .topBarTrailing){
                            Button{
                                showSettingSheet = true
                            }label: {
                                Image(systemName: "ellipsis")
                                
                            }
                        }
                        
                    }
                }
            }
            
        }
    
    

    @ViewBuilder
    var buttonView: some View{
        HStack(spacing: 20){
            Button("Shuffle"){
                withAnimation{gridViewModel.shuffle()}
                gridViewModel.checkForBingo()
            }
                .padding(10)
                .overlay{
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(Color.primary)
                }
            Button("Deselect all"){gridViewModel.deselectAll()}
                .padding(10)
                .overlay{
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(Color.primary)
                }
        }.foregroundStyle(.primary)
            .fontWeight(.medium)
    }
    
    @ViewBuilder
    var promptTitleView: some View{
        HStack{
            TextField("Type in the prompt", text: $prompt)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Generate"){
                gptViewModel.generateBingoDescriptions(from: prompt)
            }
            .disabled(prompt.isEmpty)
            .buttonStyle(PrimaryButtonStyle())
        }
        .padding()
        
    }
    
    @ViewBuilder
    var bingoProgressView: some View{
        Spacer()
        HStack{
            Spacer()
            VStack{
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                Text("Generating...")
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        Spacer()
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
