//
//  ConfirmUsersView.swift
//  Friday2
//
//  Created by Bruce Jagid on 7/18/21.
//

import SwiftUI

struct ConfirmUsersView: View {
    
    @EnvironmentObject var Map: UserSocialMap
    @Binding var isPlanPlanning: Bool
    @Binding var isPlanConfirming: Bool
    
    
    var body: some View {
        ForEach(Map.getUsersFromCurrentPlan()){ User in
            Group{
                Image(uiImage: User.profilePic)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 2 * DefaultIconRadius, height: 2 * DefaultIconRadius)
                Circle()
                    .stroke(lineWidth: IconLineWidth)
                    .frame(width: 2 * DefaultIconRadius, height: 2 * DefaultIconRadius)
                    .foregroundColor(IconRingColor)
                    .opacity(IconRingOpacity)
            }
            .scaleEffect(2)
            .position(x: getUserXLayoutPosition(User, in: Map.getUsersFromCurrentPlan()), y: getUserYLayoutPosition(User, in: Map.getUsersFromCurrentPlan()))
            .gesture(DeletePressGesture(User))
        }
        .scaleEffect(isPlanConfirming ? 1 : (isPlanPlanning ? 3 : 0))
        .opacity(isPlanConfirming ? 1 : 0)
        .frame(minWidth: 400, maxWidth: 400, minHeight: 400, maxHeight: .infinity, alignment: .center)
        
    }
    
    
    func DeletePressGesture(_ User: Person) -> some Gesture{
        let DeleteGesture = LongPressGesture(minimumDuration: 0.5, maximumDistance: 20)
            .onEnded(){_ in
                Map.removeUserFromPlan(User)
            }
        
        return DeleteGesture
    }

}

