//
//  IdentifiableExtensions.swift
//  Friday2
//
//  Created by Bruce Jagid on 7/18/21.
//

import Foundation

func GetFirstPosition<Content: Identifiable>(_ Content: Content, in Contents: [Content]) -> Int?{
    for Position in 0..<Contents.count{
        if(Contents[Position].id == Content.id){
            return Position
        }
    }
    return nil
    
}

func GetFirstPosition(_ Content: String, in Contents: [String]) -> Int?{
    for Position in 0..<Contents.count{
        if(Contents[Position] == Content){
            return Position
        }
    }
    return nil
    
}




