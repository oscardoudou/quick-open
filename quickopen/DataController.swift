//
//  DataController.swift
//  quickopen
//
//  Created by 张壹弛 on 2/24/21.
//  Copyright © 2021 oscardoudou. All rights reserved.
//

import Foundation

open class DataController: NSObject{
    public func contentsOf(folderPath: URL) -> [URL] {
        let fileManager = FileManager.default
        do {
            let contents =  try fileManager.contentsOfDirectory(atPath: folderPath.path)
                let urls = contents.map {return folderPath.appendingPathComponent($0)}
                return urls
        }catch {
            print("Error: \(error)")
            return []
        }
    }
}
