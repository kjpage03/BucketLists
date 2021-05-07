//
//  DataController.swift
//  BucketLists
//
//  Created by Kaleb Page on 3/18/21.
//

import Foundation

struct DataController {
    
    static var bucketPathName = "bucketLists"
    static var hasRecievedPathName = "value"
    
    func saveData<T: Codable>(data: T, pathName: String) {
        
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent(pathName).appendingPathExtension("plist")
        
        let propertyListEncoder = PropertyListEncoder()
        let encodedData = try? propertyListEncoder.encode(data)
        try? encodedData?.write(to: archiveURL, options: .noFileProtection)
    }
    
    
    func retrieveData(pathName: String) -> [BucketList] {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent(pathName).appendingPathExtension("plist")

        let propertyListDecoder = PropertyListDecoder()

        if let retrievedListData = try? Data(contentsOf: archiveURL), let decodedLists = try? propertyListDecoder.decode([BucketList].self, from: retrievedListData) {
            return decodedLists
        } else {
            return []
        }

    }
    
    
    func retrieveValue(pathName: String) -> [Bool]? {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let archiveURL = documentsDirectory.appendingPathComponent(pathName).appendingPathExtension("plist")

        let propertyListDecoder = PropertyListDecoder()

        if let retrievedListData = try? Data(contentsOf: archiveURL), let decodedLists = try? propertyListDecoder.decode([Bool].self, from: retrievedListData) {
            return decodedLists
        } else {
            return nil
        }

    }
    
}
