//
//  OrginizerView.swift
//  Saturday
//
//  Created by George Heisel on 7/17/21.
//

import SwiftUI

struct OrganizerView: View {
    var acceptedUsers: [UIImage] =
        [UIImage(systemName: "heart.fill")!,
         UIImage(systemName: "heart.fill")!,
         UIImage(systemName: "heart.fill")!,
         UIImage(systemName: "heart.fill")!,
         UIImage(systemName: "heart.fill")!,
         UIImage(systemName: "heart.fill")!,
         UIImage(systemName: "heart.fill")!,
         UIImage(systemName: "heart.fill")!,
         UIImage(systemName: "heart.fill")!,
         UIImage(systemName: "heart.fill")!
        ]
    var pendingUsers: [UIImage] = [UIImage(systemName: "heart.fill")!, UIImage(systemName: "heart.fill")!]
    var rejectedUsers: [UIImage] = [UIImage(systemName: "heart.fill")!]
//OLD CODE STARTED HERE, COPY ONTO LINE BELOW
    var body: some View {
        ZStack{
            OrganizerViewBackground()
            OrganizerViewText(acceptedUsers: acceptedUsers, pendingUsers: pendingUsers, rejectedUsers: rejectedUsers)
        }
        .frame(width: 350, height: 500)
    }
    

}

struct OrganizerViewBackground: View{
    var cornerRadius: CGFloat = 25.0
    var rectangleColor: Color = Color(red: 40/255 , green:221/255, blue:249/255)
    var borderColor: Color = Color(.black)

    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: cornerRadius)
            .foregroundColor(rectangleColor)
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke()
                .foregroundColor(borderColor)
        }
    }
}

struct OrganizerViewText: View {
    var acceptedUsers: [UIImage]
    var pendingUsers: [UIImage]
    var rejectedUsers: [UIImage]
    var profileSpacing: CGFloat = 10
    var profilePicSize: CGFloat = 50
    var textSize: CGFloat = 15

    var body: some View{
        VStack(spacing:0){
            HStack{
                Text("Accepted")
                    .frame(maxWidth: .infinity)
                Text("Pending")
                    .frame(maxWidth: .infinity)
                Text("Rejected")
                    .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity)
            .font(.custom("Avenir Medium", size:textSize))
            .padding()
            NiceDivider()
            ScrollView{
                HStack{
                    VStack(spacing: profileSpacing){
                        ForEach(acceptedUsers, id: \.self) {UIImage in
                            ProfileIcon(uiImage: UIImage)
                                .frame(width: profilePicSize, height: profilePicSize)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    VStack(spacing: profileSpacing){
                        ForEach(pendingUsers, id: \.self) {UIImage in
                            ProfileIcon(uiImage: UIImage)
                                .frame(width: profilePicSize, height: profilePicSize)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    VStack(spacing: profileSpacing){
                        ForEach(rejectedUsers, id: \.self) {UIImage in
                            ProfileIcon(uiImage: UIImage)
                                .frame(width: profilePicSize, height: profilePicSize)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }
                .padding(.bottom, profileSpacing)
                .padding(.top, profileSpacing)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .padding(.leading)
            .padding(.trailing)
        }
    }
}

struct OrganizerView_Previews: PreviewProvider {
    static var previews: some View {
        OrganizerView()
    }
}







#if DEBUG

struct OrganizerViewContainerPreview: View {
    @State var acceptedUsers: [UIImage]

    var body: some View {
        OrganizerView(acceptedUsers: $acceptedUsers)
    }
}

struct OrganizerView_Previews: PreviewProvider {
    static var previews: some View {
        OrganizerView(acceptedUsers: [
                UIImage(systemName: "heart.fill")
            ]
        )
    }
}

#endif








//MARK: OLD CODE

//    var body: some View {
//        ZStack(alignment: Alignment(horizontal: .center, vertical: .top)){
//            ColumnHolder()
//            OrganizerText()
//            VStack(spacing:0){
//                Column()
//                    .frame(width:125)
//                Rectangle()
//                    .frame(width:350, height:1)
//                Spacer()
//                Spacer()
//                Spacer()
//            }
//        }
//        .padding(.horizontal)
//        .frame(width: 350, height: 500, alignment: .center)
//    }
//}
//
//struct OrganizerText:View{
//    var body: some View{
//        VStack{
//            HStack{
//                Text("Accepted")
//                    .padding(20)
//                Text("Pending")
//                    .padding(20)
//                Text("Rejected")
//                    .padding(20)
//            }
//            Rectangle()
//                .frame(height:1)
//        }
//    }
//}
//struct ColumnHolder: View{
//    var body: some View{
//        ZStack{
//        RoundedRectangle(cornerRadius: 25.0)
//            .frame(width: 350, height: 500, alignment: .center)
//            .foregroundColor(Color(red: 40/255 , green:221/255, blue:249/255))
//        RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
//            .stroke()
//            .foregroundColor(.black)
//        }
//    }
//}
//struct Column: View{
//    var body: some View{
//        Rectangle()
//            .stroke()
//            .frame(maxHeight:.infinity)
//    }
//}
