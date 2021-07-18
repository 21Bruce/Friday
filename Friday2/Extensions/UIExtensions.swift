//
//  UIExtensions.swift
//  Friday2
//
//  Created by Bruce Jagid on 7/18/21.
//

import Foundation
import CoreGraphics
import SwiftUI

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor{
    static func random() -> UIColor {
        return UIColor(
            red: .random(),
            green: .random(),
            blue: .random(),
            alpha: 1
        )
    }
}

extension CGSize: AdditiveArithmetic{
    
    public static func - (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width - rhs.width, height: lhs.height - rhs.height)
    }
    
    public static func + (lhs: CGSize, rhs: CGSize) -> CGSize {
        CGSize(width: lhs.width + rhs.width, height: lhs.height + rhs.height)
    }
    
    func scale(by number: CGFloat) -> CGSize{
        CGSize(width: self.width * number, height: self.height * number)
        
    }
    
    func cgpointify() -> CGPoint{
        CGPoint(x: self.width, y: self.height)
    }
    
    func unitpointify(in geometry: GeometryProxy) -> UnitPoint{
        UnitPoint(x: self.width/geometry.size.width, y: self.height/geometry.size.height)
    }
    
    var magnitude: CGFloat{
        sqrt(self.width * self.width + self.height * self.height)
    }
    
    var magnitudeSquared: CGFloat{
        self.width * self.width + self.height * self.height
    }
}

extension CGPoint: AdditiveArithmetic{
    
    public static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }
    
    public static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
    
    func scale(by number: CGFloat) -> CGPoint{
        CGPoint(x: self.x * number, y: self.y * number)
        
    }
    
    func sizeify() -> CGSize{
        CGSize(width: self.x, height: self.y)
    }
    
    func convert(_ geometry: GeometryProxy, in coordinateSpace: CoordinateSpace) -> CGPoint{
        CGPoint(x: self.x - geometry.frame(in: coordinateSpace).width/2, y: self.y - geometry.frame(in: coordinateSpace).height/2)
    }
    
    var magnitude: CGFloat{
        sqrt(self.x * self.x + self.y * self.y)
    }
    
    var magnitudeSquared: CGFloat{
        self.x * self.x + self.y * self.y
    }
    
    
}

extension Date {

    var localizedDate: Date {

        let dateFormatter = DateFormatter()

        let dateFormat = "yyyy-MM-dd HH:mm"
        dateFormatter.dateFormat = dateFormat
        let formattedDate = dateFormatter.string(from: self)

        dateFormatter.locale = NSLocale.current
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")

        dateFormatter.dateFormat = dateFormat as String
        let sourceDate = dateFormatter.date(from: formattedDate as String)

        return sourceDate!
    }
}

