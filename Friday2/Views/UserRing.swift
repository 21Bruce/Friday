//
//  UserRing.swift
//  Friday2
//
//  Created by Bruce Jagid on 7/18/21.
//

import SwiftUI

struct UserRing: View, Identifiable {
    
    @EnvironmentObject var UserSocialMap: UserSocialMap
    @State var Radius: CGFloat
    @Binding var isPlanSelecting: Bool
    @Binding var SelectedRingPosition: Int?
    @State var isIconInThisSelected: Bool = false
    
    var Level: Level
    var ViewForContent: (Person, Binding<Bool>) -> IconView
    var id: Int
    
    private var RadianSpace: CGFloat

    
    init(isPlanSelecting: Binding<Bool>, SelectedRingPosition: Binding<Int?>, Level: Level, ViewForContent: @escaping (Person, Binding<Bool>) -> IconView) {
        
        self.Level = Level
        self.RadianSpace = 2.0 * Pi/CGFloat(Level.Contents.count)
        self.id = Level.id
        self.Radius = DefaultRingRadius * CGFloat(self.id)
        self.ViewForContent = ViewForContent
        _isPlanSelecting = isPlanSelecting
        _SelectedRingPosition = SelectedRingPosition

    }
    
    var body: some View {
        GeometryReader{geometry in
            ZStack{
                
                Circle()
                    .stroke(lineWidth: isThisRingHoveredOver ? ExtendedLineWidth : StandardLineWidth)
                    .frame(width: Radius * 2, height: Radius * 2, alignment: .center)
                    .position(x: geometry.frame(in: .named("inZoomable")).size.width/2, y: geometry.frame(in: .named("inZoomable")).size.height/2)
                
                ForEach(Level.Contents) {User in
                    
                    let ContentArcSpace = CGFloat(GetFirstPosition(User, in: Level.Contents)!) * RadianSpace
                    let InitialOffset = CGSize(width: Radius * cos(ContentArcSpace - RadianOffset), height: Radius * sin(ContentArcSpace - RadianOffset))
                    
                    ViewForContent(User, $isIconInThisSelected)
                        .offset(InitialOffset)//This positions the icon's on the rings. It may seem weird to do this here but the rings ought to position the views on them
                
                }
            }
            .zIndex(isIconInThisSelected ? 1 : 0)
        }
        
        
    }
    
    var isThisRingHoveredOver: Bool{
        !isPlanSelecting && SelectedRingPosition == self.id
    }
    
    

    
    
    }


//MARK: Control Panel
let StandardLineWidth: CGFloat = 2
let ExtendedLineWidth: CGFloat = StandardLineWidth * 3

