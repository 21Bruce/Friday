//
//  PostView.swift
//  Friday2
//
//  Created by Bruce Jagid on 7/18/21.
//

import SwiftUI

struct PostView: View {
    @EnvironmentObject var Map: UserSocialMap
    
    var body: some View {
        ScrollView(){
            VStack(alignment:.leading,spacing: 0){
                
                ForEach(0..<Map.myPosts.count, id: \.self){position in
                    
                ZStack{
                    Text(Map.myPosts[position])
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .padding(10)
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Rectangle()
                        .stroke(lineWidth: 2)
                        .foregroundColor(Color(red: 220/255, green: 220/255, blue: 220/255))
                        .frame(maxWidth:.infinity)
                }
                .offset(x:0, y: 10)
                .frame(maxWidth:.infinity, alignment: .leading)
                }
        }
    }
        
}
}
struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
