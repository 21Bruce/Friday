//
//  ProfileTabView.swift
//  Friday2
//
//  Created by Bruce Jagid on 7/18/21.
//

import SwiftUI

struct ProfileTabBar: View{
    @Binding var selectedTab: String

    var body: some View{
        ZStack{
            ZStack{
                HStack(spacing: 125){
                    
//                        ProfileTabButton(title: "Thoughts", img: UIImage(systemName: "text.bubble")!, selectedTab: $selectedTab)
                        
                        
                        ProfileTabButton(title: "Plans", img: UIImage(systemName: "person.3")!, selectedTab: $selectedTab)
                    
                    }
                
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(lineWidth: 2)
//                    .foregroundColor(.gray)
//                    .frame(width: 130, height: 35, alignment: .center)
//                    .offset(x: selectedTab == "Thoughts" ? -96 : 0, y: 0)
//                    .offset(x: selectedTab == "Plans" ? 90 : 0, y: 0)
//
//
                }
                
                Rectangle().stroke().foregroundColor(.gray).frame(maxWidth: .infinity, maxHeight: 50)
        }
    }
        
        
        
        
    }


struct ProfileTabButton: View{
    
    var title: String
    var img: UIImage
    @Binding var selectedTab: String
    
    
    var body: some View{
        Button(action: {withAnimation(){selectedTab = title}}){
                VStack(spacing: 5){
                        Image(uiImage: img)
                            .renderingMode(.template)
                    }
                
                .foregroundColor(selectedTab == title ? Color.black : Color.gray)
                .padding(.horizontal)
            
        }
    }

}
