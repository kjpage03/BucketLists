//
//  BucketList.swift
//  BucketLists
//
//  Created by Kaleb Page on 3/10/21.
//
import Foundation
import UIKit

struct BucketList: Hashable, Codable {
    
    var id = UUID()
    var owner: String
    var items: [Item]
    var color: Color
    var percentCompleted: Double {
        guard items.count != 0 else { return 0 }
        var completedItems: [Item] = []
        
        items.forEach { (item) in
            if item.isComplete {
                completedItems.append(item)
            }
        }
        let decimalPercent = Double(completedItems.count) / Double(items.count)
        print(decimalPercent)
        return decimalPercent
    }
}

struct Group: Codable {
    var items: [Item]
}

struct Item: Hashable, Codable {
    var id = UUID()
    var name: String
    var description: String
    var location: Location?
    var goalDate: Date?
    var isComplete: Bool
    var photos: [Data]?
    var details: String
    var imageArray: [String]
    var numofSteps: Int
    var subSteps: [Substep]?
}

struct Substep: Codable, Hashable {
    var name: String
    var isComplete: Bool
}

struct Location: Codable, Hashable {
    var latitude: String
    var longitude: String
    var location: String
}

struct Color : Codable, Hashable {
    var red : CGFloat = 0.0, green: CGFloat = 0.0, blue: CGFloat = 0.0, alpha: CGFloat = 0.0
    
    var uiColor : UIColor {
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    init(uiColor : UIColor) {
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    }
}



