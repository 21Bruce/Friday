//
//  IconView.swift
//  Friday2
//
//  Created by Bruce Jagid on 7/18/21.
//

import SwiftUI
import CoreLocation
import Mixpanel

struct IconView: View {
    
    @EnvironmentObject var Map: UserSocialMap
    
    var User: Person
    
    @State var Radius = DefaultIconRadius
    @State var OffsetTotal: CGSize = CGSize.zero
    @State var OffsetUpdated: CGSize =  CGSize.zero
    @State var isInBubble = false
    @State var isIconSelected = false
    @Binding var isRingSelected: Bool
    @Binding var isPlanSelecting: Bool
    @Binding var isPlanConfirming: Bool
    @Binding var SelectedRingPosition: Int?
    @Binding var postUsername: String
    @Binding var postToDisplay: String
    @Binding var isPostScreen: Bool
    @Binding var isMainScreen: Bool
    
    
    
    var body: some View {
        //View for each User Icon
        
        ZStack {
            GeometryReader{ geometry in
                Group{
                    Image(uiImage: User.profilePic)
                        .resizable()
                        .clipShape(Circle())
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 2 * Radius, height: 2 * Radius)
                    Circle()
                        .stroke(lineWidth: IconLineWidth)
                        .foregroundColor(IconRingColor)
                        .opacity(IconRingOpacity)
                        .frame(width: 2 * Radius, height: 2 * Radius)
                }
                .onTapGesture {
                    Mixpanel.mainInstance().track(event: "Viewed Thought")
                    if(!isPlanSelecting){
                        withAnimation(){
                            postToDisplay = Map.postsInbox[User.id] ?? ""
                            postUsername = Map.getFriendUsernameWithID(User.id) ?? ""
                            isMainScreen = false
                            isPostScreen = true
                        }
                    }
                    
                }
                .position((geometry.frame(in: .named("inZoomable")).size.scale(by: 0.5) + OffsetTotal + OffsetUpdated).cgpointify()) //Add all the offsets and convert them to a screen point
                .scaleEffect(isIconSelected ? 2 : (isInBubble ? 0 : 1), anchor: (geometry.frame(in: .named("inZoomable")).size.scale(by: 0.5) + OffsetTotal + OffsetUpdated).unitpointify(in: geometry)) // if we are selected scale us by 2, if we are in a bubble, scale us to zero, otherwise keep us at our regular size
                .opacity(isInBubble ? 0 : 1) // if we are in the bubble then turn off the view
                .onChange(of: isPlanSelecting, perform: { value in //if the bubble is popped or we leave to do something else, reset the Icons
                    withAnimation(){
                        if(!value){
                            OffsetUpdated = CGSize.zero
                            OffsetTotal = CGSize.zero
                            isInBubble = false
                        }
                    }
                })
                .gesture(LongPressDragGesture(in: geometry))//LongPress + Drag Gesture for Group making or Ring shifting
                Image(systemName: "exclamationmark.bubble.fill")
                    .resizable()
                    .frame(width: 2 * Radius, height: 2 * Radius)
                    .foregroundColor(Color(red: 0.9254901960784314, green: 0.7686274509803922, blue: 0.8))
                    .position(x: geometry.size.width/2 + 25, y: geometry.size.height/2 - 34)
                    .opacity(false && !isIconSelected ? 1 : 0) // this indicator is off for now
            }
        }
        .zIndex(isIconSelected ? 2 : 0)
    }
    
    
    
    //                .scaleEffect(isInBubble ? 0 : 1, anchor: (geometry.frame(in: .named("inZoomable")).size.scale(by: 0.5) + OffsetTotal + OffsetUpdated).unitpointify(in: geometry)) // if we are in a bubble scale us to zero
    
    
    
    //MARK: Gestures
    
    //LongPress + Drag Gesture
    func LongPressDragGesture(in geometryProxy: GeometryProxy) -> some Gesture{
        
        //The Long Press before the Drag
        let LongPressGesture = LongPressGesture(minimumDuration: isPlanSelecting ? 0.05 : 0.2, maximumDistance: 0)
            .onEnded(){ _ in
                withAnimation(){
                    //send a signal to other relevant views(the ring that contains this one) that we have been picked up
                    isRingSelected = true
                    isIconSelected = true
                }
            }
        
        //The Drag
        let DragGesture = DragGesture(coordinateSpace: .named("inZoomable"))
            .onChanged(){value in
                withAnimation(){
                    
                    self.OffsetUpdated = value.translation //Move the user as finger moves
                    
                    //Convert absolute screen coordinates from dumb top left coordinates to center based cooridnates like a normal person would do
                    let Centered = value.location.convert(geometryProxy, in: .named("inZoomable"))
                    let Magnitude = Centered.magnitude
                    let MagnitudeSquared = Centered.magnitudeSquared
                    
                    
                    
                    
                    //is the drag within the inner ring
                    var bubbleDetected: Bool{
                        MagnitudeSquared < BubbleDetectionRingRadius * BubbleDetectionRingRadius
                    }
                    
                    //Take the magnitude and divide it by the base ring radius. Since each ring's radius is a multiple of the first, this will be an integer(or close to one) if we are on a ring
                    var ringMultiplier: CGFloat{
                        Magnitude / DefaultRingRadius
                    }
                    
                    //is the drag within the ring structure
                    var insideOuterRing: Bool{
                        Int(ringMultiplier.rounded() - 1) < Map.levels.count
                    }
                    
                    //is the drag hovering close to a ring
                    var nearARing: Bool{
                        insideOuterRing && (ringMultiplier * DefaultRingRadius) - 2 <= Magnitude && Magnitude <= (ringMultiplier * DefaultRingRadius) + 2
                    }
                    
                    
                    //if the drag is in the bubble detection range and bubble is not formed, then fucking form it
                    if(bubbleDetected && !isPlanSelecting){
                        isPlanSelecting.toggle()
                    }
                    
                    //if we are near a ring that is not ours and we are not in a plan state, then update the selected ring
                    if(nearARing && !isPlanSelecting){
                        SelectedRingPosition = Int(ringMultiplier.rounded())
                        
                    }else{
                        SelectedRingPosition = nil
                    }
                    
                }
                
            }
            .onEnded(){value in
                withAnimation(){
                    //Deselect us
                    isRingSelected = false
                    isIconSelected = false
                    
                    //Take the screen coordinates and convert them to regular coordinates
                    let Centered = value.location.convert(geometryProxy, in: .named("inZoomable"))
                    let Magnitude = Centered.magnitude
                    let MagnitudeSquared = Centered.magnitudeSquared
                    
                    //Check to see if the user's magnitude squared is equal to the bubble radius squared
                    var landedInBubble: Bool{
                        MagnitudeSquared < DefaultBubbleRadius * DefaultBubbleRadius
                    }
                    
                    
                    //Take the magnitude and divide it by the base ring radius. Since each ring's radius is a multiple of the first, this will be even
                    var ringMultiplier: CGFloat{
                        Magnitude / DefaultRingRadius
                    }
                    
                    var insideOuterRing: Bool{
                        Int(ringMultiplier.rounded()-1) < Map.levels.count
                    }
                    
                    //is the drag hovering over a ring
                    var nearARing: Bool{
                        insideOuterRing && (ringMultiplier * DefaultRingRadius) - 1 <= Magnitude && Magnitude <= (ringMultiplier * DefaultRingRadius) + 1
                        
                    }
                    
                    
                    //If the drop is in the bubble, update the recorded offset, reset the offset accumulator
                    if(landedInBubble){
                        OffsetTotal += OffsetUpdated //Store the offset update
                        OffsetUpdated = CGSize.zero //Reset the offset accumulator
                        isInBubble = true //animate the change
                        Map.addUserToPlan(User) //add the user to the plan
                    }else{ //If the drop does not land in the bubble, reset the Offset altogether
                        OffsetTotal = CGSize.zero
                        OffsetUpdated = CGSize.zero
                        isInBubble = false
                    }
                    
                    //If the drop operation lands on a ring, move the user to that ring in the model
                    if(nearARing && !isPlanSelecting){
                        withAnimation(){
                            SelectedRingPosition = nil
                            Map.moveUser(User, from: Map.userLevel(User)!, to: Map.levels[Int(ringMultiplier.rounded()) - 1]) //move the user in the model
                        }
                        
                    }
                    
                    
                }
                
            }
        
        return LongPressGesture.sequenced(before: DragGesture)
        
    }
    
    
}






