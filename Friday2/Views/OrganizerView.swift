//
//  OrginizerView.swift
//  Saturday
//
//  Created by George Heisel on 7/17/21.
//

import SwiftUI

struct OrganizerView: View {
    @Binding var acceptedUsers: [UIImage]
//    @Binding var pendingUsers: [UIImage]
//    @Binding var rejectedUsers: [UIImage]
//OLD CODE STARTED HERE, COPY ONTO LINE BELOW
    var body: some View {
        ZStack{
            OrganizerViewBackground()
            OrganizerViewText(acceptedUsers: acceptedUsers)
        }
        .frame(width: 350, height: 500, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
    

}

struct OrganizerViewBackground: View{
    var body: some View{
        ZStack{
            RoundedRectangle(cornerRadius: 25.0)
            .foregroundColor(Color(red: 40/255 , green:221/255, blue:249/255))
            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                .stroke()
                .foregroundColor(.black)
        }
    }
}

struct OrganizerViewText: View {
    var acceptedUsers: [UIImage]
    //@Binding var pendingUsers: [UIImage]
    //@Binding var rejectedUsers: [UIImage]
    
    var body: some View{
        VStack{
            HStack{
                Text("Accepted")
                Text("Pending")
                Text("Rejected")
            NiceDivider()
                ScrollView{
                    HStack{
                        VStack{
                            ForEach(acceptedUsers, id: \.self) {UIImage in
                                ProfileIcon(uiImage: UIImage)
                            }
                        }
                        VStack{
                            
                        }
                        VStack{
                       
                        }
                    }
                }
            }
        }
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
