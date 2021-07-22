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
    @State var isPlanCoordinationShown: Bool = false
    let gridColumns: [GridItem] = [
        GridItem(.fixed(170),spacing: 5, alignment: nil),
        GridItem(.fixed(170),spacing: 5, alignment: nil),
    ]
    var body: some View {
        VStack{
            ZStack{
                Rectangle()
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    
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
                    
                    
                    
                    
                }
            .frame(height:DefaultMainUserIconRadius * 3)
              
                    ProfileTabBar(selectedTab: $selectedTab)
                        .opacity(planPreview != nil ? 0 : 1)
                       
                    
                
                if(selectedTab == "Plans"){
                    ZStack{
                        if(Map.plans.count != 0){
                            ScrollView(showsIndicators: false){
                            LazyVGrid(columns: gridColumns ){
                            ForEach(Map.plans){Plan in
                                EventGrid()
                                    .padding(5)
                                .opacity(planPreview != nil ? 0 : 1)
                                .foregroundColor(Color(red: Plan.red, green: Plan.green, blue: Plan.blue, opacity: 1))
                                    .frame(height:100)
                                .onTapGesture {
                                    withAnimation(.linear(duration: 0.5)){
                                        if(planPreview == nil){
                                            planPreview = Plan
                                        }
                                            
                                        }
                                    }
                                
                            }
                        }
                    }
                            .padding(10)
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
                                    Text("Micheal Seibel's Birthday")
                                        .font(.custom("Avenir Medium", size: 18))
                                    Text("\(planPreview?.date.description ?? "")")
                                        .font(.custom("Avenir Medium", size: 14))
                                    Text("Location:  \(planPreview?.address ?? "")")
                                        .font(.custom("Avenir Medium", size: 14))
                                    Button(action: {isPlanCoordinationShown.toggle()}, label: {
                                        ZStack{
                                            RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                                                .foregroundColor(Color(red: 40/255 , green:221/255, blue:249/255))
                                            Text("Suggest Changes")
                                                .font(.custom("Avenir Medium", size: 10))
                                                .foregroundColor(.black)
                                        }
                                    })
                                    .buttonStyle(BorderlessButtonStyle())
                                    .frame(height:18)
                                    .padding(3)
                                    .fullScreenCover(isPresented:$isPlanCoordinationShown, onDismiss: {isPlanCoordinationShown = false
                                    }, content: {
                                        CoordinationView(showPopover: $isPlanCoordinationShown).environmentObject(Map)
                                    })
    
                                }
                            }
                            .frame(width: 180, height: 250, alignment: .center)
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
