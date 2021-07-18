//
//  PlanUserConfirmationLayout.swift
//  Friday2
//
//  Created by Bruce Jagid on 7/18/21.
//

import Foundation
import CoreGraphics

func getUserXLayoutPosition(_ User: Person, in List: [Person]) -> CGFloat{
    
    CGFloat((1 + Int(GetFirstPosition(User, in: List)! % 3)) * Int(DefaultIconRadius) * 5)
}

func getUserYLayoutPosition(_ User: Person, in List: [Person]) -> CGFloat{
    
    CGFloat((1 + Int(GetFirstPosition(User, in: List)! / 3)) * Int(DefaultIconRadius) * 5)
}
