//
//  BucketList.swift
//  BucketLists
//
//  Created by Chris Harding on 3/10/21.
//

import Foundation

struct BucketList: Hashable {
    var owner: String
    var items: [Item]
    var color: String
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
