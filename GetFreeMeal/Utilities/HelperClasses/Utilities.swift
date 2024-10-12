//
//  Utilities.swift
//  FreeMeal
//
//  Created by Rakhi Kumari on 15/09/24.
//

import Foundation

class Utilities {
    
    static func convertToStringDict(_ dict: [String: Any?]) -> [String: String] {
        var newDict = [String: String]()
        for (key, value) in dict {
            if let value {
                newDict[key] = "\(value)"
            }
        }
        return newDict
    }
    
    
}
