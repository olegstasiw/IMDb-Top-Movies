//
//  ImageCacheManager.swift
//  IMDb Top Movies
//
//  Created by Oleh Stasiv on 24.03.2023.
//
//

import Foundation

protocol ImageCacheService {
    func write(filename: String, data: Data, errorCompletion: @escaping(Error?) -> Void)
    func read(fileName: String) -> Data?
}

class ImageCacheManager: ImageCacheService {
    
    private let fileManager: FileManager
    
    private let libraryDirectoryPathURL: URL = {
        let paths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
        let libraryDirectoryPath = paths[0]
        let libraryDirectoryPathURL = URL(fileURLWithPath: libraryDirectoryPath)
        return libraryDirectoryPathURL.appendingPathComponent("imageCache")
    }()
    
    init() {
        self.fileManager = FileManager.default
        createDirectoryIfNeeded()
    }
    
    func write(filename: String, data: Data, errorCompletion: @escaping(Error?) -> Void) {
        let fileURL = libraryDirectoryPathURL.appendingPathComponent(filename)
        do {
            try data.write(to: fileURL)
        } catch {
            errorCompletion(error)
        }
    }
    
    func read(fileName: String) -> Data? {
        let fileURL = libraryDirectoryPathURL.appendingPathComponent(fileName)
        guard let data = try? Data(contentsOf: fileURL) else {
            return nil
        }
        return data
    }
    
    private func createDirectoryIfNeeded() {
        if !fileManager.fileExists(atPath: libraryDirectoryPathURL.path) {
            try? fileManager.createDirectory(at: libraryDirectoryPathURL, withIntermediateDirectories: false, attributes: nil)
        }
    }
}

public extension NSKeyedUnarchiver {
   static func unarchiveObjectWithoutSecureCoding<DecodedObjectType>(of cls: DecodedObjectType.Type,
                                                                     from data: Data) -> DecodedObjectType? where DecodedObjectType: NSObject, DecodedObjectType: NSCoding {
       guard let self = try? NSKeyedUnarchiver(forReadingFrom: data) else {
           return nil
       }
       self.requiresSecureCoding = false
       return self.decodeObject(of: cls, forKey: NSKeyedArchiveRootObjectKey)
   }
}
