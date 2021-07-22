//
//  NiceDividers.swift
//  Friday2
//
//  Created by Aidan Murphy on 7/19/21.
//

import SwiftUI

struct NiceDivider: View{
    var body: some View{
        Rectangle()
            .fill(Color.gray)
            .frame(height: 2)
            .edgesIgnoringSafeArea(.horizontal)
    }
}
