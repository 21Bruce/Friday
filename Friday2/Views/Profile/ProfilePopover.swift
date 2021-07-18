//
//  ProfilePopover.swift
//  Friday2
//
//  Created by Bruce Jagid on 7/18/21.
//

import SwiftUI

struct ProfilePopover<SubView: View>: ViewModifier {
    let popover: SubView
    let isPresented: Bool
    
    
    init(isPresented: Bool, @ViewBuilder content: () -> SubView){
        self.isPresented = isPresented
        popover = content()
    }
    
    
    
    func body(content: Content) -> some View{
        content
            .overlay(overlayContent())
    }
    
    
    @ViewBuilder private func overlayContent() -> some View{
        GeometryReader{ geometry in
            if isPresented {
                popover
                    .transition(.scale)
                    .frame(width: geometry.size.width, height: geometry.size.height)
            }
            
        }
    }
    
    
    
}


