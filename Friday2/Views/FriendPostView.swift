//
//  FriendPostView.swift
//  Friday2
//
//  Created by Bruce Jagid on 7/18/21.
//

import SwiftUI

struct FriendPostModifiedView: View {
    @Binding var thoughtsHistory: [String]
    @Binding var username: String

    var body: some View {
        GeometryReader{geometry in
            VStack(spacing:0){
                Text(username + " is thinking:")
                    .font(.title)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
                    .padding(.horizontal)
                    .frame(maxWidth: .infinity, alignment: .leading)
                NiceDivider()
                OwnThoughts(thoughtsHistory: thoughtsHistory)
                }
            }
    }
}











//MARK: DO NOT TOUCH -

#if DEBUG

struct FriendPostModifiedContainerView: View {
    @State var thoughtsHistory: [String]
    @State var username: String
    
    var body: some View{
        FriendPostModifiedView(thoughtsHistory: $thoughtsHistory, username: $username)
    }
    
}



struct FriendPostModifiedContainerView_Preview: PreviewProvider {
    static var previews: some View {
        FriendPostModifiedContainerView(thoughtsHistory:[
            "qwertyuiopasdfghjkzxcvbnm",
            "Q",
            "w",
            "e",
            "r",
            "t",
            "y",
            "u",
            "i",
            "o",
            ],
        username: "Cuppy")
    }
}

#endif

//MARK: OLD CODE BELOW

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


