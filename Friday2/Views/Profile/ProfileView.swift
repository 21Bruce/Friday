//
//  ProfileView.swift
//  Friday2
//
//  Created by Bruce Jagid on 7/18/21.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var Map: UserSocialMap
    @State var selectedTab =  "Plans"
    @State var planPreview: Plan? = nil
    
    var body: some View {
        ZStack{
            Rectangle()
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            
            
            GeometryReader{geo in
                
                ZStack{
                    Image(uiImage: Map.mainUser.profilePic)
                        .resizable()
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    
                    Circle()
                        .stroke(lineWidth: IconLineWidth)
                        .foregroundColor(IconRingColor)
                    
                }
                .frame(width: DefaultMainUserIconRadius * 2, height: DefaultMainUserIconRadius * 2)
                .opacity(planPreview != nil ? 0 : IconRingOpacity)
                .position(CGPoint(x: geo.frame(in: .named("OuterSpace")).width/2, y: 30))
                
                
                
            }
            GeometryReader{geo in
                ProfileTabBar(selectedTab: $selectedTab)
                    .opacity(planPreview != nil ? 0 : 1)
                    .position(CGPoint(x: geo.frame(in: .named("OuterSpace")).width/2, y:100))
                
            }
            if(selectedTab == "Plans"){
                ZStack{
                    if(Map.plans.count != 0){
                        ForEach(Map.plans){Plan in
                            ZStack{
                                Group{
                                    Circle()
                                        .opacity(0.4)
                                    Circle()
                                        .stroke(lineWidth: 3)
                                        .opacity(0.75)
                                }
                            }
                            .opacity(planPreview != nil ? 0 : 1)
                            .frame(width: 2 * DefaultPlanSelectionRadius, height: 2 * DefaultPlanSelectionRadius)
                            .position(x: getPlanXPosition(Plan, in: Map.plans), y: getPlanYPosition(Plan, in: Map.plans))
                            .foregroundColor(Color(red: Plan.red, green: Plan.green, blue: Plan.blue, opacity: 1))
                            .onTapGesture {
                                withAnimation(.linear(duration: 0.5)){
                                    if(planPreview == nil){
                                        planPreview = Plan
                                        
                                    }
                                }
                            }
                            
                        }
                    }else{
                        Spacer()
                        Spacer()
                        
                    }
                    
                    
                    ZStack{
                        
                        
                        Group{
                            Circle()
                                .opacity(0.4)
                            Circle()
                                .stroke(lineWidth: 3)
                                .opacity(0.75)
                        }
                        .foregroundColor(Color(UIColor(red: CGFloat(planPreview?.red ?? 0), green: CGFloat(planPreview?.green ?? 0), blue: CGFloat(planPreview?.blue ?? 0), alpha: 1)))
                        .scaleEffect(planPreview != nil ? 22 : 0)
                        .frame(width: 2 * DefaultPlanSelectionRadius, height: 2 * DefaultPlanSelectionRadius, alignment: .center)
                        
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(.white)
                            VStack{
                                Text("Date: \(planPreview?.date.description ?? "")")
                                Text("Location:  \(planPreview?.address ?? "")")
                            }
                        }
                        .frame(width: 200, height: 200, alignment: .center)
                        .scaleEffect(planPreview != nil ? 2 : 0)
                        
                        
                    }
                    .onTapGesture{
                        withAnimation(.linear(duration: 0.5)){
                            if(planPreview != nil){
                                planPreview = nil
                                
                            }
                        }
                    }
                    .opacity(planPreview != nil ? 1 : 0)
                    
                    
                    
                }
                .transition(.move(edge: .leading))
                
            }
            if (selectedTab == "Thoughts"){
                GeometryReader{geo in
                    PostView()
                        .position(CGPoint(x: geo.frame(in: .named("OuterSpace")).width/2, y:520))
                    
                }
            }
            else{
            }
            
        }
    }
    
}


struct ProfileViewPreviews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(UserSocialMap())
    }
}
