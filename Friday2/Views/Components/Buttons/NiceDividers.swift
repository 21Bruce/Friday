//
//  NiceDividers.swift
//  Friday2
//
//  Created by Aidan Murphy on 7/19/21.
//

import SwiftUI

struct NiceDivider: View{
    let color: Color = .gray
    let width: CGFloat = 2
    var body: some View{
        Rectangle()
            .fill(color)
            .frame(height: width)
            .edgesIgnoringSafeArea(.horizontal)
    }
}
