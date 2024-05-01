//
//  SheetView.swift
//  BingoAI
//
//  Created by Zachary Tao on 4/30/24.
//

import SwiftUI

enum GridType: String, CaseIterable, Identifiable{
    case four = "4 X 4"
    case five = "5 X 5"
    var id: String { self.rawValue }
    
}

struct SheetView: View {
    @ObservedObject var userSettings = UserSettings.shared
    
    var body: some View {
        VStack{
            Form{
                Section("Select Grid Type"){
                    Picker("Select Grid Type", selection: $userSettings.gridType){
                        ForEach(GridType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }            .pickerStyle(SegmentedPickerStyle())
                }

            }
        }
    }
}

#Preview {
    SheetView()
}
