//
//  FriendRequestView.swift
//  Friday2
//
//  Created by Bruce Jagid on 7/18/21.
//

import SwiftUI
import Mixpanel

struct FriendRequestView: View {
    
    @EnvironmentObject var Map: UserSocialMap
    @Binding var isDisplayed: Bool
    
    var body: some View {
        ExitButton(onSubmit:{isDisplayed = false})
            .frame(width: 30, height: 30)
            VStack{
                    GeometryReader{geometry in
                    Text(Map.friendInbox.isEmpty ? "No Friend Requests" : "Friend Requests")
                        .foregroundColor(Map.friendInbox.isEmpty ? .gray : .black)
                        .padding(.vertical)
                        .position(x: geometry.size.width/2, y: 30)

                    }
                   
                
                List{
                    ForEach(Array(Map.friendInbox.keys), id: \.self){username in
                        HStack{
                            Text(username)
                            
                            Spacer()
                            
                            Button(action: {acceptRequest(from: username)}, label: {
                                ZStack{
                                    Circle()
                                        .foregroundColor(.green)
                                    Image(systemName: "person.crop.circle.badge.checkmark")
                                        .foregroundColor(.black)
                                        .frame(width: 30, height: 30)
                                }
                                
                            })
                            .buttonStyle(BorderlessButtonStyle())
                            .frame(width: 40, height: 40)
                            .padding(.trailing)
                            
                            Button(action: {denyRequest(from: username)}, label: {
                                ZStack{
                                    Circle()
                                        .foregroundColor(.red)
                                    Image(systemName: "person.crop.circle.badge.xmark")
                                        .foregroundColor(.black)
                                        .frame(width: 30, height: 30)
                                }
                                
                            })
                            .buttonStyle(BorderlessButtonStyle())
                            .frame(width: 40, height: 40)
                        }
                        
                    }
                
            }
            
            
        }
        
        
    }
    
    func denyRequest(from username: String){
        Mixpanel.mainInstance().track(event: "Friend Request Denied")
        Map.denyFriendRequest(from: username, with: Map.friendInbox[username]!)
    }
    
    func acceptRequest(from username: String){
        Mixpanel.mainInstance().track(event: "Friend Request Accepted")
        Map.acceptFriendRequest(from: username, with: Map.friendInbox[username]!)
    }




}

