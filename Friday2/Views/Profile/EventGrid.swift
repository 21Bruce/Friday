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
                    .foregroundColor(.white)
                RoundedRectangle(cornerRadius: 25.0)
                    .stroke(lineWidth: 3)
                    .opacity(100)
            }
            Text("Micheal Seibel is a special man")
                .font(.custom("Avenir Medium", size: 15))
                .foregroundColor(.black)
        }
    }

}
struct EventGrid_Previews: PreviewProvider {
    static var previews: some View {
        EventGrid()
    }
}
