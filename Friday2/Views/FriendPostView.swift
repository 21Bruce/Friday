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
    @Binding var profilePic: UIImage

    var body: some View {
        GeometryReader{geometry in
            VStack(spacing:0) {
                ZStack() {
                    ProfileIcon(uiImage: profilePic)
                        .frame(width: 200, height:230)
                    HStack{
                        Spacer()
                        VStack{
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .foregroundColor(.red)
                                .buttonStyle(BorderlessButtonStyle())
//The ExitButton struct goes above, when ready for implementation
                                .frame(width: 25, height: 25)
                                .padding(10)
                            Spacer()
                        }
                    }
                }
                .frame(height:230)
                Text(username + " is thinking:")
                    .multilineTextAlignment(.leading)
                    .font(.custom("Avenir Medium", size:40))
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
    @State var profilePic: UIImage
    
    var body: some View{
        FriendPostModifiedView(thoughtsHistory: $thoughtsHistory, username: $username, profilePic: $profilePic)
    }
}

struct FriendPostModifiedContainerView_Preview: PreviewProvider {
    static var previews: some View {
        FriendPostModifiedContainerView(thoughtsHistory:[
            "qwertyuiopasdfghjkzxcvbnm",
            "Q",
            "ezsxrtyunytdfuvygbiygubygbuygbvuygbvuygvuyvuygvuygvyugvuyvguygvuygvygvygvygvgyvyggvy",
            "e",
            "r",
            "t",
            "y",
            "u",
            "i",
            "o",
            ],
            username: "Cuppy",
            profilePic: UIImage(systemName: "heart.fill")!)
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


