//
//  ProfileIcon.swift
//  Friday2
//
//  Created by Aidan Murphy on 7/19/21.
//

import SwiftUI

struct ProfileIcon: View {
    @State var User: Person
    @State var Radius = DefaultIconRadius

    var body: some View {
        ZStack {
            GeometryReader{ geometry in
                Group{
                    Image(uiImage: User.profilePic)
                        .resizable()
                        .clipShape(Circle())
                        .aspectRatio(1, contentMode: .fit)
                    Circle()
                        .stroke(lineWidth: IconLineWidth)
                        .foregroundColor(IconRingColor)
                        .opacity(IconRingOpacity)
                }
            }
        }
    }
}

