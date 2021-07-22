//
//  OrginizerView.swift
//  Saturday
//
//  Created by George Heisel on 7/17/21.
//

import SwiftUI

struct OrganizerView: View {
    var frameHeight: CGFloat = 500
    var frameWidth: CGFloat = 350
    
    @Binding var acceptedImgs: [String: UIImage]
    @Binding var acceptedNames: [String]
    @Binding var pendingImgs: [String: UIImage]
    @Binding var pendingNames: [String]
    @Binding var rejectedImgs: [String: UIImage]
    @Binding var rejectedNames: [String]

    var body: some View {
        ZStack{
            OrganizerViewBackground()
            OrganizerViewText(
                acceptedImgs: acceptedImgs,
                acceptedNames: acceptedNames,
                pendingImgs: pendingImgs,
                pendingNames: pendingNames,
                rejectedImgs: rejectedImgs,
                rejectedNames: rejectedNames
            )
        }
        .frame(width: frameWidth, height: frameHeight)
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
    var profileSpacing: CGFloat = 10
    var textSize: CGFloat = 20

    var acceptedImgs: [String: UIImage]
    var acceptedNames: [String]
    var pendingImgs: [String: UIImage]
    var pendingNames:[String]
    var rejectedImgs: [String: UIImage]
    var rejectedNames: [String]

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
            CNiceDividers(Color: .black, Width: 2)
            ScrollView{
                HStack{
                    VStack(spacing: profileSpacing){
                        ForEach(acceptedNames, id: \.self) {String in
                            ProfilePicwName(
                                userName: String,
                                userPic: acceptedImgs[String]!
                            )
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    VStack(spacing: profileSpacing){
                        ForEach(pendingNames, id: \.self) {String in
                            ProfilePicwName(
                                userName: String,
                                userPic: pendingImgs[String]!
                            )
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    VStack(spacing: profileSpacing){
                        ForEach(rejectedNames, id: \.self) {String in
                            ProfilePicwName(
                                userName: String,
                                userPic: rejectedImgs[String]!
                            )
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

struct ProfilePicwName: View{
    var profilePicSize: CGFloat = 50
    var userTextSize: CGFloat = 15
    var spaceInPicwName: CGFloat = 2
    @State var userName: String
    @State var userPic: UIImage
    
    var body: some View {
        VStack(spacing:spaceInPicwName){
            ProfileIcon(uiImage:userPic)
                .frame(width: profilePicSize, height: profilePicSize)
            Text(userName)
                .font(.custom("Avenir Medium", size:userTextSize))
        }
    }
}



//MARK: DO NOT TOUCH

#if DEBUG

struct OrganizerViewContainerPreview: View {
    @State var acceptedImgs: [String: UIImage]
    @State var acceptedNames: [String]
    @State var pendingImgs: [String: UIImage]
    @State var pendingNames: [String]
    @State var rejectedImgs: [String: UIImage]
    @State var rejectedNames: [String]

    var body: some View {
        OrganizerView(
            acceptedImgs: $acceptedImgs,
            acceptedNames: $acceptedNames,
            pendingImgs: $pendingImgs,
            pendingNames: $pendingNames,
            rejectedImgs: $rejectedImgs,
            rejectedNames: $rejectedNames
        )
    }
}

struct OrganizerView_Previews: PreviewProvider {
    static var previews: some View {
        OrganizerViewContainerPreview(
            acceptedImgs: ["Cuppy": UIImage(systemName: "heart.fill")!],
            acceptedNames: ["Cuppy"],
            pendingImgs: ["Coco": UIImage(systemName: "heart.fill")!],
            pendingNames: ["Coco"],
            rejectedImgs: ["Obama": UIImage(systemName: "heart.fill")!],
            rejectedNames: ["Obama"]
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
