//
//  GeneralQuestionView.swift
//  Friday2
//
//  Created by George Heisel on 7/18/21.
//

import SwiftUI

struct GeneralQuestionView: View {
    @EnvironmentObject var Map: UserSocialMap
    @State private var characterCount = 0
    @State private var lastGeneralQuestion = ""
    @Binding private var showPopover : Bool
    @Binding var ask : String
    init(showPopover: Binding<Bool>,
         ask: Binding<String>) {
        _showPopover = showPopover
        _ask = ask
        UITextView.appearance().backgroundColor = .clear
    }
    var body: some View {
        Color(.white)
        VStack(spacing:1){
            HStack{
                Spacer()
                ExitButton(onSubmit: {showPopover = false})
                    .frame(width: 30, height: 30)
                    .padding(5)
            }
                VStack{
                  
                    ZStack(alignment:.topLeading){
                        if ask.isEmpty{
                            Text("Ask a question...")
                                .offset(x:4, y: 7.6)
                                .foregroundColor(.gray)
                            
                        }
                        
                        TextEditor(text:$ask)
                            .multilineTextAlignment(.leading)
                            .onChange(of: ask, perform: { text in
                                characterCount = ask.count
                                if characterCount <= 100 {
                                    lastGeneralQuestion = ask
                                } else {
                                    self.ask = lastGeneralQuestion
                                }
                                
                            })
                        
                    }
                    
        }
    
}
    }
}

