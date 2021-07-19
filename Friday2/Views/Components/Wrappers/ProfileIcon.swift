//
//  ProfileIcon.swift
//  Friday2
//
//  Created by Aidan Murphy on 7/19/21.
//

import SwiftUI

struct ProfileIcon: View {
    @State var uiImage = UIImage()
    @State var Radius = DefaultIconRadius

    var body: some View {
        ZStack {
            Group{
                Image(uiImage: uiImage)
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

