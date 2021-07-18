//
//  FriendPostView.swift
//  Friday2
//
//  Created by Bruce Jagid on 7/18/21.
//

import SwiftUI

struct FriendPostView: View {
    @Binding var post: String
    @Binding var username: String
    
    init(post: Binding<String>, username: Binding<String>){
        _post = post
        _username = username
    }
    
    var body: some View {
        GeometryReader{geometry in
            VStack{
                Text(username + " is thinking:")
                    .font(.title)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                List{
                    Text(post)
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
               
                }
            }
            
        
       
    }
}


