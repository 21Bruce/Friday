//
//  OwnThoughts.swift
//  Friday2
//
//  Created by Aidan Murphy on 7/18/21.
//

import SwiftUI


struct OwnThoughts: View {
    @State var thoughtsHistory: [String]
    var body: some View {
        ScrollView() {
            VStack(spacing:0) {
                ForEach(thoughtsHistory, id: \.self) {String in
                    OneThoughtView(thought: String)
                }
            }
        }
    }
}
//What if they have the same ID? Possible Problem.
    //Solveable by unique IDs?

struct OneThoughtView: View{
    var thought: String
    var body: some View{
        VStack(alignment:.leading, spacing:0) {
            Text(thought)
                .lineLimit(nil)
                .padding(.leading)
                .padding(.trailing)
                .font(.title)
            NiceDivider()
        }
    }
}
//Individual ThoughtView

struct OwnThoughts_Previews: PreviewProvider {
    static var previews: some View {
        OwnThoughts(thoughtsHistory:
            ["QWERTYUIOPASDFGHJKLZXCVBNM",
            "qwerty"])
    }
}
