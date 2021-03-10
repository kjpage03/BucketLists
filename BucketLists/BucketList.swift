//
//  BucketList.swift
//  BucketLists
//
//  Created by Kaleb Page on 3/10/21.
//

import Foundation

struct BucketList {
    var owner: String
    var items: [Item]
    var color: String
}

struct Group {
    var items: [Item]
}

struct Item {
    var name: String
    var description: String
    var location: String?
    var goalDate: Date
}
