//
//  DataController.swift
//  BucketLists
//
//  Created by Kaleb Page on 3/18/21.
//

import Foundation

struct DataController {
    
    static var pathName = "bucketLists"
    
    func saveData(lists: [BucketList]) {
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent(DataController.pathName).appendingPathExtension("plist")
        
        let propertyListEncoder = PropertyListEncoder()
        let encodedLists = try? propertyListEncoder.encode(lists)
        try? encodedLists?.write(to: archiveURL, options: .noFileProtection)
    }
    
    func retrieveData() -> [BucketList] {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent(DataController.pathName).appendingPathExtension("plist")
        
        let propertyListDecoder = PropertyListDecoder()
        
        if let retrievedListData = try? Data(contentsOf: archiveURL), let decodedLists = try? propertyListDecoder.decode([BucketList].self, from: retrievedListData) {
            print(decodedLists)
            return decodedLists
        } else {
            return []
        }
        
    }
    
}
