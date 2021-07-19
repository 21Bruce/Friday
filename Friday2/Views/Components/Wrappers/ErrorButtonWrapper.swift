//
//  ErrorButtonWrapper.swift
//  Friday2
//
//  Created by Bruce Jagid on 7/18/21.
//

import SwiftUI

struct ExitButtonWrapper<Wrapped: View>: View {
    @State var onSubmit: () -> Void
    let wrapped: Wrapped
    
    init(onSubmit: @escaping () -> Void, @ViewBuilder wrapped: @escaping () -> Wrapped){
        self._onSubmit = State(wrappedValue: onSubmit)
        self.wrapped = wrapped()
    }
    
    
    var body: some View {
        ZStack{
            wrapped
            
            GeometryReader{geometry in
                Button(action: {onSubmit()}, label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.red)
                })
                .buttonStyle(BorderlessButtonStyle())
                .position(x: geometry.size.width - 30, y: 30)
            }
        }
        
    }
}







// This is annoying
