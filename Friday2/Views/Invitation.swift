//
//  Invitation.swift
//  Friday2
//
//  Created by Bruce Jagid on 7/18/21.
//

import SwiftUI
import Mixpanel

struct Invitations: View {
    
    @EnvironmentObject var Map: UserSocialMap
    @Binding private var showPopover: Bool
    @State var isCoordinationViewShown: Bool = false
    init(showPopover: Binding<Bool>){
        _showPopover = showPopover
    }
    var body: some View {
        
        ScrollView{
            VStack{
                Text(Map.planInboxIDs.isEmpty ? "No Plan Requests" : "Plan Requests")
                    .foregroundColor(Map.friendInbox.isEmpty ? .gray : .black)
                    .padding(.vertical)
                ForEach(Map.planInboxIDs, id:\.self){invitationID in
                    ZStack{
                        RoundedRectangle(cornerRadius: 25.0)
                            .foregroundColor(Color(red: 200/255 , green: 200/255, blue: 200/255))
                        VStack{
                            Text(Map.planInboxRawData[invitationID]![1])
                                .lineLimit(nil)
                                .font(.custom("Avenir Medium", size: 25))
                                .padding(10)
                                .foregroundColor(.black)
                            Text("From: \(Map.getFriendUsernameWithID(Map.planInboxRawData[invitationID]![0]) ?? "")")
                                .lineLimit(nil)
                                .font(.custom("Avenir Medium", size: 15))
                                .padding(2)
                                .foregroundColor(.black)
                            Text("Date and Time: \(Map.planInboxRawData[invitationID]![2])")
                                .lineLimit(nil)
                                .font(.custom("Avenir Medium", size: 15))
                                .padding(2)
                                .foregroundColor(.black)
                            Text("Location: \(Map.planInboxRawData[invitationID]![3])")
                                .lineLimit(nil)
                                .font(.custom("Avenir Medium", size: 15))
                                .padding(2)
                                .foregroundColor(.black)
                            VStack{
                            HStack{
                                Button(action: {acceptRequest(invitationID)}, label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 25.0)
                                            .foregroundColor(Color(red: 51/255 , green: 255/255, blue: 153/255))
                                        Text("Yes")
                                            .font(.custom("Avenir Medium", size: 18))
                                            .foregroundColor(.black)
                                    }
                                }
                                )
                                .buttonStyle(BorderlessButtonStyle())
                                .frame(height: 40)
                                .padding(10)
                                Button(action: {rejectRequest(invitationID)}, label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                            .foregroundColor(Color(red: 255/255 , green:100/255, blue:100/255))
                                        Text("No")
                                            .font(.custom("Avenir Medium", size: 18))
                                            .foregroundColor(.black)
                                    }
                                })
                                .buttonStyle(BorderlessButtonStyle())
                                .frame(height: 40)
                                .padding(10)
                            }
                                Button(action: {isCoordinationViewShown.toggle()}, label: {
                                    ZStack{
                                        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                            .foregroundColor(Color(red: 40/255 , green:221/255, blue:249/255))
                                        Text("Suggest Changes")
                                            .font(.custom("Avenir Medium", size: 18))
                                            .foregroundColor(.black)
                                    }
                                })
                                .buttonStyle(BorderlessButtonStyle())
                                .frame(height: 40)
                                .padding(10)
                                .sheet(isPresented:$isCoordinationViewShown, onDismiss: {isCoordinationViewShown = false}, content: {
                                        CoordinationView(showPopover: $isCoordinationViewShown).environmentObject(Map)})
                            }
                        }
                    }
                }
            }
        }
    }

    func acceptRequest(_ planID: String){
        Mixpanel.mainInstance().track(event: "Accept Plan Request")
        Map.acceptPlanRequest(planID)
    }
    
    func rejectRequest(_ planID: String){
        Mixpanel.mainInstance().track(event: "Reject Plan Request")
        Map.rejectPlanRequest(planID)
    }

}

