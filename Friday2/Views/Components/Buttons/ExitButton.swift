//
//  ExitButton.swift
//  Friday2
//
//  Created by George Heisel on 7/18/21.
//

import SwiftUI

struct ExitButton: View {
    
    @State var onSubmit: () -> Void
    
    init(onSubmit: @escaping () -> Void){
        _onSubmit = State(wrappedValue: onSubmit)
    }
    
    var body: some View {
        ZStack{
            Button(action: {onSubmit()}, label: {
                
        Image(systemName: "xmark.circle.fill")
            .resizable()
            .foregroundColor(.red)
            })
            .buttonStyle(BorderlessButtonStyle())
        }
    }
}


