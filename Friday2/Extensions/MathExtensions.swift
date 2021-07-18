//
//  MathExtensions.swift
//  Friday2
//
//  Created by Bruce Jagid on 7/18/21.
//

import Foundation



func Exp<Value: Numeric>(raise base: Value, to power: Int) -> Value{
    var accumulator: Value = 1
    
    for _ in 0..<power{
        accumulator *= base
    }
    
    return accumulator
}

extension Double {
    static func random() -> Double {
        return Double(arc4random()) / Double(UInt32.max)
    }
}


