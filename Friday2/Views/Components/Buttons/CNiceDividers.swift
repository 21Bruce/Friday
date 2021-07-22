//
//  CNiceDividers.swift
//  Friday2
//
//  Created by Aidan Murphy on 7/22/21.
//

import SwiftUI

struct CNiceDividers: View {
    var Color: Color
    var Width: CGFloat
    var body: some View{
        Rectangle()
            .fill(Color)
            .frame(height: Width)
            .edgesIgnoringSafeArea(.horizontal)
    }
}
