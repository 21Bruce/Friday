//
//  RingSelection.swift
//  Friday2
//
//  Created by Bruce Jagid on 7/18/21.
//

import SwiftUI

struct RingSelection<ButtonLabel: View>: View {
    @State var selectedRings: [Bool]
    @State var isNoneSelected: Bool
    @State var onSubmit: ([Bool]) -> Void
    @State var onSelect: ([Bool]) -> Void
    let message: Text
    let warning: Text
    let exitButtonLabel: ButtonLabel
    
    init(
        selectedRings: [Bool] = [Bool](repeating: false, count: 3), // initial selection preference for rings
        @ViewBuilder message: @escaping () -> Text, // instructions to display
        @ViewBuilder warning: @escaping () -> Text, //warning to display when no rings are selected
        @ViewBuilder exitButtonLabel: @escaping () -> ButtonLabel, //label for the exit button
        onSubmit: @escaping (_ selectedRings: [Bool]) -> Void, //action for the exit button
        onSelect: @escaping (_ selectedRings: [Bool]) -> Void = {_ in} // action that triggers when a ring is selected. Defaults to no action
    ){
        self.exitButtonLabel = exitButtonLabel()
        self.message = message()
        self.warning = warning()
        self._onSubmit = State(wrappedValue: onSubmit)
        self._onSelect = State(wrappedValue: onSelect)
        self._selectedRings = State(wrappedValue: selectedRings)
        self._isNoneSelected = State(wrappedValue: !selectedRings.contains(true))
    }
    
    var body: some View {
        ZStack{
            GeometryReader{geometry in
                message
                    .font(.custom("Avenir Medium", size: 15))
                    .foregroundColor(.gray)
                    .position(x: geometry.size.width/2, y: 70)
                
                ForEach(1 ..< selectedRings.count + 1){position in
                    Ring(ringPosition: CGFloat(position), isSelected: $selectedRings[position-1])
                        .onTapGesture{
                            if position == 1 && selectedRings[0] && !selectedRings[1...].contains(true){
                                isNoneSelected = true
                                selectedRings[0] = false
                            }else{
                                isNoneSelected = false
                                for i in 0..<selectedRings.count{
                                    if(i+1 > position){
                                        selectedRings[i] = false
                                    }else{
                                        selectedRings[i] = true
                                    }
                                }// End for loop
                            }// End Outer Else
                        onSelect(selectedRings)
                        }// End OnTapGesture
                }// End ForEach
                .scaleEffect(scaledCoordSystem)
                .position(x: geometry.size.width/2, y: geometry.size.height/2)
                
                warning
                    .font(.custom("Avenir Medium", size: 15))
                    .foregroundColor(.gray)
                    .opacity(isNoneSelected ? 1 : 0)
                    .position(x: geometry.size.width/2, y: geometry.size.height - 80)
                
                
                Button(action: {onSubmit(selectedRings)}, label: {exitButtonLabel})
                    .position(x: geometry.size.width/2, y: geometry.size.height - 30)
                
            } // End GeometryReader
        }// End ZStack
    } // End Body
}// End RingSelection

struct Ring: View{
    @State var ringPosition: CGFloat
    @Binding var isSelected: Bool
    var body: some View {
        Circle()
            .stroke(lineWidth: isSelected ? 7 : 5)
            .foregroundColor(isSelected ? .red : .black)
            .frame(width: ringPosition * DefaultRingRadius * 2, height: ringPosition * DefaultRingRadius * 2)
    }
}

