//
//  PlanCollectionLayout.swift
//  Friday2
//
//  Created by Bruce Jagid on 7/18/21.
//

import SwiftUI
import CoreGraphics

func getPlanXPosition(_ plan: Plan, in plans: [Plan]) -> CGFloat{
    let Position = GetFirstPosition(plan, in: plans)!
    return CGFloat((2 + Int(3 * (Position % 4))) * Int(DefaultPlanSelectionRadius))
}

func getPlanYPosition(_ plan: Plan, in plans: [Plan]) -> CGFloat{
    let Position = GetFirstPosition(plan, in: plans)!
    return CGFloat((6 + Int(3 * (Position / 4))) * Int(DefaultPlanSelectionRadius))

}
