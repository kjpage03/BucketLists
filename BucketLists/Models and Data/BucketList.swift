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
    
    static var testBucketLists = [BucketList(owner: "Kaleb's List", items: [
       
        Item(name: "Go to Canada", description: "See a hockey game, try some syrup, and ride a moose", location: nil, goalDate: Date(), isComplete: false, details: "", imageArray: [], numberofSteps: 0, stepsArray: []),
        Item(name: "Go Skydiving", description: "Jump off a plane", location: nil, goalDate: Date(), isComplete: false, details: "", imageArray: [], numberofSteps: 0, stepsArray: []),
        Item(name: "Go to California", description: "Beaches n stuff", location: nil, goalDate: Date(), isComplete: true, details: "", imageArray: [], numberofSteps: 0, stepsArray: []),
        Item(name: "Purchase a sports car", description: "Probably a Corvette C8", location: nil, goalDate: Date(), isComplete: false, details: "", imageArray: [], numberofSteps: 0, stepsArray: [])
        
    ], color: Color(uiColor: .red)), BucketList(owner: "Chris's List", items: [
                                   

                                                    Item(name: "Go to Japan", description: "Take a trip to japan and eat sushi", location: nil, goalDate: Date(), isComplete: false, details: "", imageArray: [], numberofSteps: 0, stepsArray: []),
                                                    Item(name: "Go to Germany", description: "Take a trip to Germany", location: nil, goalDate: Date(), isComplete: false, details: "", imageArray: [], numberofSteps: 0, stepsArray: []),
                                                    Item(name: "The the Grand Canyon", description: "Plant a trip to go visit the Gran Canyon someday", location: nil, goalDate: Date(), isComplete: true, details: "", imageArray: [], numberofSteps: 0, stepsArray: []),
                                                    Item(name: "Finish school", description: "Finish going to school", location: nil, goalDate: Date(), isComplete: true, details: "", imageArray: [], numberofSteps: 0, stepsArray: [])],
                                 
       color: Color(uiColor: .blue)), BucketList(owner: "Jake's List", items: [], color: Color(uiColor: .yellow))]
}

struct Group: Codable {
    var items: [Item]
}

struct Item: Hashable, Codable {
    var id = UUID()
    var name: String
    var description: String
    var location: Location?
    var goalDate: Date
    var isComplete: Bool
    var photos: [Data]?
    var details: String
    var imageArray: [String]
    var numberofSteps: Int
    var stepsArray: [String]
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



