//
//  BucketList.swift
//  BucketLists
//
//  Created by Kaleb Page on 3/10/21.
//
import Foundation
import UIKit


struct BucketList: Hashable, Codable {
    
    var owner: String
    var items: [Item]
    var color: Color
    var percentCompleted: Double {
        var completedItems: [Item] = []
        
        items.forEach { (item) in
            if item.isComplete {
                completedItems.append(item)
            }
        }
        let decimalPercent = Double(completedItems.count) / Double(items.count)
        print(decimalPercent)
        return decimalPercent
//            * 100
    }
    
//    func getPercentage(items: [Item]) -> Double {
//        var completedItems: [Item] = []
//
//        items.forEach { (item) in
//            if item.isComplete {
//                completedItems.append(item)
//            }
//        }
//        let decimalPercent = Double(completedItems.count) / Double(items.count)
//        print(decimalPercent)
//        return decimalPercent * 100
//    }
    
    static var testBucketLists = [BucketList(owner: "Kaleb's List", items: [
       
        Item(name: "Go to Canada", description: "See a hockey game, try some syrup, and ride a moose", location: nil, goalDate: Date(), isComplete: false),
        Item(name: "Go Skydiving", description: "Jump off a plane", location: nil, goalDate: Date(), isComplete: false),
        Item(name: "Go to California", description: "Beaches n stuff", location: nil, goalDate: Date(), isComplete: true),
        Item(name: "Purchase a sports car", description: "Probably a Corvette C8", location: nil, goalDate: Date(), isComplete: false)
        
    ], color: Color(uiColor: .red)), BucketList(owner: "Chris's List", items: [
                                   
        Item(name: "Go to Japan", description: "Take a trip to japan and eat sushi", location: "Japan", goalDate: Date(), isComplete: false),
        Item(name: "Go to Germany", description: "Take a trip to Germany", location: "Germany", goalDate: Date(), isComplete: false),
        Item(name: "The the Grand Canyon", description: "Plant a trip to go visit the Gran Canyon someday", location: "Grand Canyon", goalDate: Date(), isComplete: true),
        Item(name: "Finish school", description: "Finish going to school", location: "Grand Canyon", goalDate: Date(), isComplete: true)],
                                 
       color: Color(uiColor: .blue)), BucketList(owner: "Jake's List", items: [], color: Color(uiColor: .yellow))]
}

struct Group: Codable {
    var items: [Item]
}

struct Item: Hashable, Codable {
    var name: String
    var description: String
    var location: String?
    var goalDate: Date
    var isComplete: Bool
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



