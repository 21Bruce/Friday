//
//  EventGrid.swift
//  Saturday
//
//  Created by George Heisel on 7/16/21.
//

import SwiftUI

struct EventGrid: View {
    var body: some View {
       
        ZStack{
            Group{
                RoundedRectangle(cornerRadius: 25.0)
                    .opacity(0.4)
                RoundedRectangle(cornerRadius: 25.0)
                    .stroke(lineWidth: 3)
                    .opacity(1)
            }
            Text("Micheal Seibel is a Special man")
        }
    }

}
struct EventGrid_Previews: PreviewProvider {
    static var previews: some View {
        EventGrid()
    }
}
