//
//  GameModel.swift
//  BingoAI
//
//  Created by Zachary Tao on 1/1/24.
//
import Foundation
import SwiftUI

struct BingoSlot : Identifiable, Hashable{
    var id = UUID()
    var description: String
    var isSelected: Bool
}

