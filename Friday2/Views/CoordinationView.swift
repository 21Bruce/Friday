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
    init(showPopover: Binding<Bool>) {
        _showPopover = showPopover
    }

    var body: some View {
        VStack(spacing:10){
            ZStack{
                HStack{
                    HStack{
                    Image(systemName: "gear")
                    Text("Plan Coordination")
                        .font(.custom("Avenir Medium", size: 20))
                    }
                    .padding(.horizontal)
                    Spacer()
                    Button(action: {showPopover=false}, label: {
                        
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
                    .frame(width: 30, height: 30)
                    })
                    .buttonStyle(BorderlessButtonStyle())
                }
                    }
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
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
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
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
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                ZStack
                {
                    GrayRoundedButton()
                        .frame(maxWidth:.infinity)
                    HStack{
                Image(systemName:"clock.fill")
                    .foregroundColor(.black)
                Text("Sugget a Different Time")
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
                Image(systemName:"calendar")
                    .foregroundColor(.black)
                Text("Suggest a Different Date")
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
            Spacer()
        }
        .padding(.horizontal)
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




