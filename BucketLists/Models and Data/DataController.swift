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
    
    //file:///Users/kalebpage/Library/Developer/CoreSimulator/Devices/1B17A21C-AC6A-45C4-AD10-89B0823D8978/data/Containers/Data/Application/9D44B7A1-612A-4944-987D-0F19ACDA8731/Documents/value.plist
    
    //GENERIC FUNCTION
    
//    func retrieveData<T: Codable>(pathName: String) -> T? {
//
//        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
//        let archiveURL = documentsDirectory.appendingPathComponent(pathName).appendingPathExtension("plist")
//
//        let propertyListDecoder = PropertyListDecoder()
//
//        if let retrievedListData = try? Data(contentsOf: archiveURL) {
//            print(retrievedListData)
//            if let decodedData = try? propertyListDecoder.decode(T.self, from: retrievedListData) {
//    //            print(decodedLists)
//                return decodedData
//            } else {
//                return nil
//            }
//        } else {
//            return nil
//        }
//
//    }
    
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
