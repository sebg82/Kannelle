//
//  ContentManager.swift
//  Kannelle
//
//  Created by Sebastien Gohier on 09/10/2019.
//  Copyright © 2019 Sebastien Gohier. All rights reserved.
//

import Foundation

class ContentManager {
    
    func getLocalVideosUrl() -> [URL] {
        do {
            return try FileManager.default
                .contentsOfDirectory(at: C.documentsURL, includingPropertiesForKeys: nil)
                .filter { $0.pathExtension == "mov" }
        }
        catch { return [] }
    }
    
    
}
