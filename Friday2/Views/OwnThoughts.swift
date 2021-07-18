//
//  OwnThoughts.swift
//  Friday2
//
//  Created by Aidan Murphy on 7/18/21.
//

import SwiftUI

struct EzDivider: View{
    let color: Color = .gray
    let width: CGFloat = 2
    var body: some View{
        Rectangle()
            .fill(color)
            .frame(height: width)
            .edgesIgnoringSafeArea(.horizontal)
    }
}
//Dividers

struct OwnThoughts: View {
    var body: some View {
        ScrollView() {
            VStack(spacing:0) {
                ForEach(myThoughts, id: \.self.name) {MyThought in
                OneThoughtView(thought: MyThought.name)
                }
                EzDivider()
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
            EzDivider()
            Text(thought)
                .lineLimit(nil)
                .padding(.leading)
                .padding(.trailing)
                .font(.title)
        }
    }
}
//Individual ThoughtView

struct OwnThoughts_Previews: PreviewProvider {
    static var previews: some View {
        OwnThoughts()
    }
}

//PlaceHolder for [Strings] that will contain a history of the user's own thoughts, recalled by Servers
//the [Strings] mentioned above is called myThoughts
struct MyThought{
    let name: String
}
let myThoughts: [MyThought] = [
    MyThought(name: "QWETqwertyuiopasdfghjklzxcvbnm,asdfgh"),
    MyThought(name: "QWET"),
    MyThought(name: "CVBN"),
    MyThought(name: "GTYU"),
    MyThought(name: "QWETqwertyuiopasdfghjklzxcvbnm,asdfgh"),
    MyThought(name: "QWET"),
    MyThought(name: "CVBN"),
    MyThought(name: "GTYU"),
    MyThought(name: "QWETqwertyuiopasdfghjklzxcvbnm,asdfgh"),
    MyThought(name: "QWET"),
    MyThought(name: "CVBN"),
    MyThought(name: "GTYU"),
    MyThought(name: "QWETqwertyuiopasdfghjklzxcvbnm,asdfgh"),
    MyThought(name: "QWET"),
    MyThought(name: "CVBN"),
    MyThought(name: "GTYU"),
    MyThought(name: "QWETqwertyuiopasdfghjklzxcvbnm,asdfgh"),
    MyThought(name: "QWET"),
    MyThought(name: "CVBN"),
    MyThought(name: "GTYU"),
    ]
