//
//  BucketList.swift
//  BucketLists
//
//  Created by Kaleb Page on 3/10/21.
//
import Foundation
import UIKit
struct BucketList: Hashable {
    var owner: String
    var items: [Item]
    var color: UIColor
}

struct Group {
    var items: [Item]
}

struct Item: Hashable {
    var name: String
    var description: String
    var location: String?
    var goalDate: Date
}
