//
//  HelpScreen.swift
//  Saturday
//
//  Created by George Heisel on 7/15/21.
//

import SwiftUI

struct HelpScreen: View {
    var body: some View {
        VStack(spacing:20){
            HStack{
                Spacer()
                ZStack{
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.red)
                .frame(width: 30, height: 30)
                }
                .buttonStyle(BorderlessButtonStyle())
            }
            ZStack{
                GrayRoundedButton()
        Text("If you have any problems,suggestions, or feedback, email us at fridaysocialtech@gmail.com or text/call at 305-849-1713")
            .font(.custom("Avenir Medium", size: 20))
            .foregroundColor(.black)
            .padding(20)
            }
            .frame(width: 300, height: 200, alignment: .center)
            Spacer()
        }
    }
}

struct HelpScreen_Previews: PreviewProvider {
    static var previews: some View {
        HelpScreen()
    }
}
