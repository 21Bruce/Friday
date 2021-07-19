//
//  UserSocialMapView.swift
//  Friday2
//
//  Created by Bruce Jagid on 7/18/21.
//

import CoreLocation
import SwiftUI
import Mixpanel

struct UserSocialMapView: View {
    
    //ViewModel and State Managment
    @StateObject var Map: UserSocialMap
    @State var SelectedRingPosition: Int? = nil
    @State var planSuccess: Bool = false
    @State var isMainScreen: Bool = false
    @State var isLoginScreen: Bool = true
    @State var isCreateAccount: Bool = false
    @State var createThoughts: Bool = false
    @State var addFriends: Bool = false
    @State var isFriendInboxDisplayed: Bool = false
    @State var isAlertedFriendRequest: Bool = false
    @State var isProfilePresented: Bool = false
    @State var isMovingIcons: Bool = false
    @State var isPlanSelecting: Bool = false
    @State var isPlanConfirming: Bool = false
    @State var isPlanPlanning: Bool = false
    @State var viewInvites: Bool = false
    @State var messageRingSelection: Bool = false
    @State var postInMaking: String = ""
    @State var postUsername: String = ""
    @State var postToDisplay: String = ""
    @State var isPostScreen: Bool = false
    
    //Map Delegate and Location Manager WIP
    @State var LocationManager = CLLocationManager()
    
    
    
    
    @ViewBuilder
    var body: some View {
        ZStack{
            if(isMainScreen){
                ZStack{
                    MapWrapperView{
                        ZStack{
                            GeometryReader{ geometry in
                                Text("Drag and drop friends into center to make plans. Tap the center bubble to continue. Hold down on the center bubble to cancel")
                                    .foregroundColor(.gray)
                                    .font(.custom("avenir medium", size: 15))
                                    .frame(alignment: .center)
                                    .position(x: geometry.frame(in: .named("inZoomable")).size.width/2, y: 10)
                                    .opacity(isPlanSelecting ? 1 : 0)
                            }
                            Bubble() //See function in View section
                            
                            RingSystem() //See function in View section
                        }
                        .zIndex(shouldBubbleExpand ? 1 : 0)
                        .coordinateSpace(name: "inZoomable")
                        .scaleEffect(scaledCoordSystem)
                    }
                    .zIndex(shouldBubbleExpand ? 1 : 0)
                    
                    //Buttons
                    GeometryReader{ geo in
                        
                        Button(action: {
                            
                            Mixpanel.mainInstance().time(event: "Create Thought")
                            createThoughts.toggle()
                        }){
                            
                            Image(systemName: "plus.bubble")
                                .resizable()
                                .foregroundColor(.black)
                                .frame(width: 30, height: 30)
                            
                        }
                        .position(x: geo.frame(in: .named("OuterSpace")).width/1.08, y: 15)
                        .sheet(isPresented:$createThoughts, onDismiss: {createThoughts = false
                        }, content: {
                            ShareThoughts(showPopover: $createThoughts, ringSelector: $messageRingSelection, isMainScreen: $isMainScreen, share: $postInMaking).environmentObject(Map)
                        })
                        
                        Button(action: {viewInvites.toggle()}){
                            
                            Image(systemName: "envelope")
                                .resizable()
                                .foregroundColor(.black)
                                .frame(width: 30, height: 25)
                            
                        }
                        .position(x: geo.frame(in: .named("OuterSpace")).width/1.23, y: 13)
                        .sheet(isPresented:$viewInvites, onDismiss: {viewInvites = false}, content: {
                            Invitations(showPopover: $viewInvites).environmentObject(Map)
                        })
                        
                        
                        Button(action: {addFriends.toggle()}){
                            Image(systemName: "person.crop.circle.badge.plus")
                                .resizable()
                                .foregroundColor(.black)
                                .frame(width: 37, height: 32)
                        }
                        .position(x: geo.frame(in:.named("OuterSpace")).width/14, y: 15)
                        .sheet(isPresented:$addFriends, onDismiss: {addFriends = false}, content: {
                            AddFriend(showPopover: $addFriends).environmentObject(Map)
                            
                        })
                        
                        Button(action: {isFriendInboxDisplayed.toggle()}){
                            Image(systemName: "tray")
                                .resizable()
                                .foregroundColor(.black)
                                .frame(width: 30, height: 30)
                        }
                        .position(x: geo.frame(in:.named("OuterSpace")).width/5.3, y: 15)
                        .sheet(isPresented: $isFriendInboxDisplayed, onDismiss: {isFriendInboxDisplayed = false}) {
                            FriendRequestView(isDisplayed: $isFriendInboxDisplayed).environmentObject(Map)
                            
                        }
                        
                    }
                    
                    
                }
                .ignoresSafeArea(shouldBubbleExpand ? .all : .keyboard, edges: shouldBubbleExpand ? .all : .bottom)
                .environmentObject(Map)
                .opacity(isMainScreen ? 1 : 0)
                .transition(.scale)
                
                ConfirmUsersView(isPlanPlanning: $isPlanPlanning, isPlanConfirming: $isPlanConfirming)
                    .environmentObject(Map)
                    .ignoresSafeArea(.all, edges: .all)
                
                
                PlanView(isPlanPlanning: $isPlanPlanning, planSuccess: $planSuccess)
                    .scaleEffect(isPlanPlanning ? 1 : 0)
                    .opacity(isPlanPlanning ? 1 : 0)
                    .environmentObject(Map)
                    .ignoresSafeArea(.all, edges: .all)
                
                
            }
            
            if(isProfilePresented){
                ProfileView()
                    .environmentObject(Map)
                    .onTapGesture {
                        withAnimation(){
                            isProfilePresented = false
                            isMainScreen = true
                        }
                    }
                    .transition(.scale)
            }
            
            if(messageRingSelection){
                RingSelection(
                    message: {
                        Text("Choose rings to broadcast thought to")
                    }, //END message
                    warning: {
                        Text("Choosing no rings will result in message deletion")
                    }, //END warning
                    exitButtonLabel: {
                        ZStack{
                            RoundedRectangle(cornerRadius: 25.0)
                                .foregroundColor(Color(red: 0.9254901960784314, green: 0.7686274509803922, blue: 0.8))
                            Image(systemName: "bubble.left")
                                .foregroundColor(.black)
                        }
                        .frame(width: 70, height: 50)
                        .opacity(messageRingSelection ? 1 : 0)
                    }, //END exitButtonLabel
                    onSubmit: {selectedRings in
                        withAnimation(){
                            var recipients:[Person] = []
                            for i in 0..<selectedRings.count{
                                if(selectedRings[i]){
                                    recipients.append(contentsOf: Map.levels[i].Contents)
                                }
                            }
                            Map.sendPost(postInMaking, to: recipients){
                                Mixpanel.mainInstance().track(event: "Create Thought", properties: ["success":$0])
                            }
                            postInMaking = ""
                            messageRingSelection = false
                            isMainScreen = true
                        }
                    }//END onSubmit
                )//END RingSelection Constructor
            }//END If MessageRingSelection
        
            if(isLoginScreen){
                LoginView(isLogin: $isLoginScreen, isCreateAccount: $isCreateAccount, isMainScreen: $isMainScreen)
                    .opacity(isLoginScreen ? 1 : 0)
                    .transition(.slide)
                    .environmentObject(Map)
                
            }
            
            if(isCreateAccount){
                AccountCreationView(isLogin: $isLoginScreen, isCreateAccount: $isCreateAccount)
                    .opacity(isCreateAccount ? 1 : 0)
                    .transition(.slide)
                    .environmentObject(Map)
                
            }
            
            if(isPostScreen){
                FriendPostView(post: $postToDisplay, username: $postUsername)
                    .transition(.scale)
                    .environmentObject(Map)
                    .onTapGesture {
                        withAnimation(){
                            isPostScreen = false
                            isMainScreen = true
                        }
                    }
            }
        } // End ZStack
        .coordinateSpace(name: "OuterSpace")
        
    } //End Body
    
    
    
    
    
    //MARK: Views that can be stored here -
    
    //Forms the plan bubble
    func Bubble() -> some View {
        GeometryReader{ geometry in
            ZStack{
                Circle()
                    .foregroundColor(.white)
                    .opacity(isBubbleNeeded ? 1 : 0)
                Circle()
                    .stroke(lineWidth: 3)
                    .foregroundColor(.white)
                    .opacity(isBubbleNeeded ? 1 : 0)
                Circle()
                    .opacity(isBubbleNeeded ? 0.4 : 0)
                Circle()
                    .stroke(lineWidth: 3)
                    .opacity(isBubbleNeeded ? 0.75 : 0)
            }
            .onChange(of: isPlanSelecting){value in
                if(value){
                    Map.destroyPlan()
                }
            }
            .scaleEffect(shouldBubbleExpand ? 7 * 1/scaledCoordSystem : 1)
            .foregroundColor(Color(red: Map.PlanInMaking.red, green: Map.PlanInMaking.green, blue: Map.PlanInMaking.blue))
            .position(x: geometry.frame(in: .named("inZoomable")).size.width/2, y: geometry.frame(in: .named("inZoomable")).size.height/2)
            .frame(width: DefaultBubbleRadius * 2, height: DefaultBubbleRadius * 2)
            .gesture(TapProceedGesture())
            .gesture(PopBubbleGesture())
            .zIndex(isPlanPlanning ? 2 : 0)
        }
    }
    
    
    
    
    
    //Creates the Ring system
    func RingSystem() -> some View{
        GeometryReader{geometry in
            
            ZStack{
                MainUserIconView() // See function in View section
                ForEach(Map.levels){level in
                    
                    UserRing(isPlanSelecting: $isPlanSelecting, SelectedRingPosition: $SelectedRingPosition, Level: level){User, isSelected in
                        
                        IconView(User: User, isRingSelected: isSelected, isPlanSelecting: $isPlanSelecting, isPlanConfirming: $isPlanConfirming, SelectedRingPosition: $SelectedRingPosition, postUsername: $postUsername, postToDisplay: $postToDisplay, isPostScreen: $isPostScreen, isMainScreen: $isMainScreen)
                        
                    }
                }
                .opacity(shouldBubbleExpand ? 0 : 1)
                .scaleEffect(isProfilePresented ? 0 : 1)
            }
            
        }
    }
    
    
    
    func MainUserIconView() -> some View{
        ZStack{
            Image(uiImage: Map.mainUser.profilePic)
                .resizable()
                .clipShape(Circle())
                .frame(width: 2 * DefaultMainUserIconRadius, height: 2 * DefaultMainUserIconRadius)
            
            Circle()
                .stroke(lineWidth: IconLineWidth)
                .foregroundColor(IconRingColor)
                .opacity(IconRingOpacity)
                .frame(width: 2 * DefaultMainUserIconRadius, height: 2 * DefaultMainUserIconRadius)
        }
        .opacity(isBubbleNeeded ? 0 : 1)
        .scaleEffect(isProfilePresented ? 0 : 1)
        .onTapGesture(){
            withAnimation(.linear(duration: 0.5)){
                isMainScreen = false
                isProfilePresented = true
            }
        }
        
    }
    
    
    
    
    
    
    //MARK: Gestures -
    
    func PopBubbleGesture() -> some Gesture{
        let PopGesture = LongPressGesture(minimumDuration: 0.2, maximumDistance: 0)
            .onEnded(){_ in
                withAnimation(.easeInOut(duration: 0.5)){
                    
                    returnToRingScreen()
                    
                    Map.destroyPlan()
                    
                }
            }
        
        
        return PopGesture
    }
    
    func TapProceedGesture() -> some Gesture{
        let ProceedGesture = TapGesture()
            .onEnded(){_ in
                withAnimation(.easeInOut(duration: 0.5)){
                    
                    if(isPlanSelecting){
                        isPlanConfirming.toggle()
                        isPlanSelecting.toggle()
                        return
                    }
                    
                    if(isPlanConfirming){
                        isPlanPlanning.toggle()
                        isPlanConfirming.toggle()
                        return
                    }
                    
                    if(isPlanPlanning){
                        isPlanPlanning.toggle()
                        planSuccess.toggle()
                        return
                    }
                    
                }
                
            }
        
        return ProceedGesture
    }
    
    
    
    //MARK: Computed Properties
    
    var isBubbleNeeded: Bool{
        isPlanSelecting || isPlanConfirming || isPlanPlanning
    }
    
    var shouldBubbleExpand: Bool{
        isPlanPlanning || isPlanConfirming
    }
    
    func returnToRingScreen(){
        isPlanPlanning = false
        isPlanConfirming = false
        isPlanSelecting = false
        isProfilePresented = false
    }
    
    
    
}

struct ShareThoughts: View {
    
    @State private var CharacterCount = 0
    @State private var LastThought = ""
    @Binding private var showPopover: Bool
    @Binding private var ringSelector: Bool
    @Binding private var isMainScreen: Bool
    @Binding var share: String
    
    init(showPopover: Binding<Bool>, ringSelector: Binding<Bool>, isMainScreen: Binding<Bool>, share: Binding<String>){
        _showPopover = showPopover
        _ringSelector = ringSelector
        _isMainScreen = isMainScreen
        _share = share
        UITextView.appearance().backgroundColor = .clear
    }
    var body : some View {
        
            VStack{
                HStack{
                    Spacer()
                    ExitButton(onSubmit: {showPopover = false})
                    .padding(10)
                        .frame(width: 30, height: 30)
                }
                ZStack(alignment:.topLeading){
                    if share.isEmpty{
                        Text("Share your thoughts...")
                            .offset(x:4, y: 7.6)
                            .foregroundColor(.gray)
                        
                    }
                    
                    TextEditor(text:$share)
                        .multilineTextAlignment(.leading)
                        .onChange(of: share, perform: { text in
                            CharacterCount = share.count
                            if CharacterCount <= 200 {
                                LastThought = share
                            } else {
                                self.share = LastThought
                            }
                            
                        })
                    
                }
                .padding()
                
                Button(action: {
                    
                    showPopover = false
                    isMainScreen = false
                    ringSelector = true
                    
                }, label: {
                    Text("Share")
                })
            }
            
        
    }
        
}


struct AddFriend: View {
    
    @EnvironmentObject var Map: UserSocialMap
    @State var name: String = ""
    @Binding var showPopover: Bool
    @State var requestState: UserFriendRequestCompletion = .success
    @State var isAlerting = false
    
    var body: some View{
        
        VStack{
            ZStack()
            {
                GeometryReader{geo in
                    Group{
                        RoundedRectangle(cornerRadius: 25).stroke()
                        
                        HStack {
                            Image(systemName: "person")
                            TextField("Username", text: $name)
                        }
                        .padding()
                        
                        
                    }
                    
                    .frame(height: 45.0)
                    .position(CGPoint(x: geo.frame(in: .named("OuterSpace")).width/2, y: 31))
                }
            }
            GeometryReader{ geo in
                Button(action: {
                    
                    sendFriendRequest()
                    
                }, label: {
                    Text("Add Friend")
                })
                .alert(isPresented: $isAlerting){
                    
                    switch requestState{
                    
                    case .success:
                        return Alert(title: Text("Sent friend request to " + name), dismissButton: .default(Text("Ok")))
                    case .userInFriends:
                        return Alert(title: Text("This User is Already Your Friend"), message: Text("You cannot add the same friend twice"), dismissButton: .default(Text("Ok")))
                    case .userNotFound:
                        return Alert(title: Text("User Not Found"), message: Text("This user does not appear to exist, check username"), dismissButton: .default(Text("Ok")))
                    case .userIsYou:
                        return Alert(title: Text("You Cannot Add Yourself"), message: Text("You cannot be your own friend. Sorry"), dismissButton: .default(Text("Ok")))
                    case .requestAlreadyPending:
                        return Alert(title: Text("You Already Sent a Request to This User"), message: Text("Wait for them to respond!"), dismissButton: .default(Text("Ok")))
                    case .unkownError:
                        return Alert(title: Text("Unkown Error"), message: Text("Unkown error encountered"), dismissButton: .default(Text("Ok")))
                    default:
                        return Alert(title: Text("This should never appear"))
                        
                    }
                }
                .frame(height:50)
                .position(CGPoint(x: geo.frame(in: .named ("OuterSpace")).width/2, y:150))
                
            }
            
            
            
            
            
        }
    }
    
    func sendFriendRequest(){
        //run query
        requestState = .waiting
        Mixpanel.mainInstance().track(event: "Friend Request Sent")
        Map.sendFriendRequest(name){result in
            
            //if the result was successful then make the sheet disappear
            
            requestState = result
            isAlerting.toggle()
            name = ""
        }
        
    }
    
    
}



struct UserSocialMapView_Previews: PreviewProvider {
    static var previews: some View {
        UserSocialMapView(Map: UserSocialMap())
    }
}




