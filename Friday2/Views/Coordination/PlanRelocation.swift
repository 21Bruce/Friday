//
//  PlanReloction.swift
//  Friday2
//
//  Created by George Heisel on 7/19/21.
//

import SwiftUI

struct PlanRelocation: View {
    @EnvironmentObject var Map: UserSocialMap
    @State var relocationText = ""
    @Binding private var showPopover : Bool
    init(showPopover: Binding<Bool>) {
        _showPopover = showPopover
        UITextView.appearance().backgroundColor = .clear}
    var body: some View {
        Color(.white)
            .ignoresSafeArea()
        VStack{
            HStack{
                Spacer()
                ExitButton(onSubmit: {showPopover = false})
                    .frame(width: 30, height: 30)
                    .padding(5)
            }
            ZStack{
                RoundedRectangle(cornerRadius: 25.0)
                    .stroke()
                    .foregroundColor(.black)
                HStack{
                    Image(systemName: "mappin.and.ellipse")
                    TextField("Relocate Plan ...", text: $relocationText)
                }
                
            }
            .frame(height:50)
            .padding(10)
            
            Spacer()
            
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                ZStack{
                    GrayRoundedButton()
                    Text("Send Suggestion")
                        .font(.custom("Avenir Medium", size: 18))
                        .foregroundColor(.black)
                }
            })
            .buttonStyle(BorderlessButtonStyle())
            .frame(height: 60)
            
        }
        
    }
}
