//
//  CoordinationView.swift
//  Saturday
//
//  Created by George Heisel on 7/16/21.
//

import SwiftUI

struct CoordinationView: View {
    
    @EnvironmentObject var Map: UserSocialMap
    @Binding private var showPopover: Bool
    @State var isGeneralQuestionShown: Bool = false
    @State var asking: String = ""
    @State var isPlanRelocationShown: Bool = false
    @State var relocating: String = ""
    @State var isNewTimeShown: Bool = false
    init(showPopover: Binding<Bool>) {
        _showPopover = showPopover
    }

    var body: some View {
        
        ZStack{
            ZStack{
            if isGeneralQuestionShown{
                        GeneralQuestionView(showPopover: $isGeneralQuestionShown, ask: $asking)
                            .transition(.move(edge: .trailing))
                            .animation(.spring())
        }
                if isPlanRelocationShown{
                    PlanRelocation(showPopover: $isPlanRelocationShown)
                        .transition(.move(edge: .trailing))
                        .animation(.spring())
                }
                if isNewTimeShown{
                    SuggestTime(showPopover: $isNewTimeShown)
                        .transition(.move(edge: .trailing))
                        .animation(.spring())
                }
            }
            .zIndex(2)
            VStack{
                ZStack{
                    HStack{
                        HStack{
                        Image(systemName: "gear")
                        Text("Plan Coordination")
                            .font(.custom("Avenir Medium", size: 20))
                        }
                        .padding(.horizontal)
                        Spacer()
                        ExitButton(onSubmit: {showPopover = false})
                            .frame(width: 30, height: 30)
                    }
                        }
                Button(action:{ isGeneralQuestionShown.toggle()}
                       , label: {
                    ZStack
                    {
                       GrayRoundedButton()
                            .frame(maxWidth:.infinity)
                        HStack{
                    Image(systemName:"questionmark.circle")
                        .foregroundColor(.black)
                    Text("General Question")
                        .font(.custom("Avenir Medium", size: 18))
                        .foregroundColor(.black)
                            Image(systemName: "arrow.right")
                                .foregroundColor(.black)
                        }
                        .padding(10)
                }
                })
                .buttonStyle(BorderlessButtonStyle())
                Button(action: {isPlanRelocationShown.toggle()}, label: {
                    ZStack
                    {
                        GrayRoundedButton()
                            .frame(maxWidth:.infinity)
                        HStack{
                    Image(systemName:"mappin.and.ellipse")
                        .foregroundColor(.black)
                    Text("Suggest Plan Relocation")
                        .font(.custom("Avenir Medium", size: 18))
                        .foregroundColor(.black)
                            Image(systemName: "arrow.right")
                                .foregroundColor(.black)
                        }
                        .padding(10)
                }
                })
                .buttonStyle(BorderlessButtonStyle())
                Button(action: {isNewTimeShown.toggle()}, label: {
                    ZStack
                    {
                        GrayRoundedButton()
                            .frame(maxWidth:.infinity)
                        HStack{
                    Image(systemName:"calendar")
                        .foregroundColor(.black)
                    Text("Sugget a Different Time or Date")
                        .font(.custom("Avenir Medium", size: 18))
                        .foregroundColor(.black)
                            Image(systemName: "arrow.right")
                                .foregroundColor(.black)
                        }
                        .padding(10)
                }
                })
                .buttonStyle(BorderlessButtonStyle())
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    ZStack
                    {
                        GrayRoundedButton()
                            .frame(maxWidth:.infinity)
                        HStack{
                    Image(systemName:"person.fill")
                        .foregroundColor(.black)
                    Text("Suggest a Friend")
                        .font(.custom("Avenir Medium", size: 18))
                        .foregroundColor(.black)
                            Image(systemName: "arrow.right")
                                .foregroundColor(.black)
                        }
                        .padding(10)
                }
                })
                .buttonStyle(BorderlessButtonStyle())
                
            }
            .padding(.horizontal)
            //end of VStack
        }
      
}
}

struct GrayRoundedButton:View{
    var body: some View{
        RoundedRectangle(cornerRadius: 25.0)
            .foregroundColor(Color(red: 200/255, green: 200/255, blue: 200/255))
                             
        RoundedRectangle(cornerRadius: 25.0)
        .stroke()
            .foregroundColor(Color(red: 0/255, green: 0/255, blue: 0/255))
    }
}




