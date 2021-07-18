//
//  AccountCreationView.swift
//  Friday2
//
//  Created by Bruce Jagid on 7/18/21.
//

import SwiftUI
import Mixpanel

struct AccountCreationView: View {
    
    @EnvironmentObject var Map: UserSocialMap
    
    @State var isAlertPresented:Bool = false
    @State var alertState: createAccountAlert = .waiting
    @State var isProfilePictureSelecting = false
    @State var email = ""
    @State var username = ""
    @State var password = ""
    @State var name = ""
    @State var isDisabled = false
    @Binding var isLogin: Bool
    @Binding var isCreateAccount: Bool

    
    
    var body: some View {
        
        if(!isProfilePictureSelecting){
            VStack(alignment: .center, spacing: 5.0) {
                VStack(alignment: .center, spacing: -40.0) {
                    
                    RoundedRectangle(cornerRadius: 25)
                        .frame(width: 105.0, height: 105.0)
                        .foregroundColor(Color(red: 0.9254901960784314, green: 0.7686274509803922, blue: 0.8))
                    
                    Text("Friday")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .offset(CGSize(width: 0, height: -30))
                    
                }
                
                
                ZStack {
                    RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).stroke()
                    
                    HStack {
                        Image(systemName: "envelope.circle.fill")
                        TextField("Email Address", text: $email)
                            .disabled(isDisabled)
                    }.padding()
                    
                }
                .frame(width: 210, height: 45)
                .padding(.vertical)
                
                ZStack {
                    RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).stroke()
                    
                    HStack {
                        Image(systemName: "person")
                        TextField(/*@START_MENU_TOKEN@*/"Username"/*@END_MENU_TOKEN@*/, text: $username)
                            .disabled(isDisabled)
                    }.padding()
                    
                }
                .frame(width: 210, height: 45)
                .padding(.vertical)
                
                
                ZStack {
                    RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                        .stroke()
                    
                    HStack {
                        Image(systemName: "lock")
                        TextField("Password", text: $password)
                            .disabled(isDisabled)
                    }
                    .padding()
                    
                }
                .frame(width: 210, height: 45)
                .padding(.bottom)
                
                
//                ZStack {
//                    RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
//                        .stroke()
//
//                    HStack {
//                        Image(systemName: "character.bubble")
//                        TextField("Full Name", text: $name)
//                    }
//                    .padding()
//
//                }
//                .frame(width: 210, height: 45)
//
                
                
                
                
                
                ZStack {
                    RoundedRectangle(cornerRadius: 25.0)
                        .foregroundColor(.gray).frame(width: 150, height: 50.0)
                    Button("Continue"){
                        guard password.count > 6 else{
                            alertState = .passwordShort
                            isAlertPresented = true
                            return
                        }
                        guard !email.isEmpty else{
                            alertState = .emailFieldEmpty
                            isAlertPresented = true
                            return
                        }
                        
                        guard !username.isEmpty else{
                            alertState = .usernameFieldEmpty
                            isAlertPresented = true
                            return
                        }
                        
                        Map.checkUsername(username){success in
                            if(success){
                                isDisabled = true
                                Mixpanel.mainInstance().time(event: "Profile Picture Selection")
                                withAnimation(){
                                    isProfilePictureSelecting.toggle()
                                }
                            }
                            
                            else{
                                alertState = .usernameTaken
                                isAlertPresented = true
                                return
                            }
                        }
                        
                        
                    }
                }
                .alert(isPresented: $isAlertPresented){
                    switch(alertState){
                    
                    case .waiting:
                        return Alert(title: Text("This Should Never Display"), message: Text("Never"), dismissButton: .default(Text("Ok")){
                            alertState = .waiting
                        })
                    case .usernameTaken:
                        return Alert(title: Text("Username Taken"), message: Text("Please pick a differen username"), dismissButton: .default(Text("Ok")){
                            alertState = .waiting
                        })
                    case .passwordShort:
                        return Alert(title: Text("Password is too short"), message: Text("Make password greater than 6 character"), dismissButton: .default(Text("Ok")){
                            alertState = .waiting
                        })
                    case .unknownError:
                        return Alert(title: Text("Unkown Error"), message: Text("Please contact our customer support"), dismissButton: .default(Text("Ok")){
                            alertState = .waiting
                        })
                    case .emailFieldEmpty:
                        return Alert(title: Text("Email field empty"), message: Text("We need an email in order to authenticate you later on"), dismissButton: .default(Text("Ok")){
                            alertState = .waiting
                        })
                    case .usernameFieldEmpty:
                        return Alert(title: Text("Username field empty"), message: Text("You need a username in order to use the app"), dismissButton: .default(Text("Ok")){
                            alertState = .waiting
                        })
                        
                    case .emailTaken:
                        return Alert(title: Text("This email already has an account linked to it"), message: Text("Please try again"), dismissButton: .default(Text("Ok")){
                            alertState = .waiting
                        })
                    }
                }
                .foregroundColor(.black)
                .padding(.top)
                
                
                ZStack {
                    RoundedRectangle(cornerRadius: 25.0)
                        .foregroundColor(.gray).frame(width:150, height: 50.0)
                    Button("Go To Sign In"){
                        //Send the user to the login screen
                        withAnimation(){
                            isCreateAccount = false
                            isLogin = true
                        }
                    }
                    .foregroundColor(.black)
                }
                
                
                
                
            }
            .opacity(isProfilePictureSelecting ? 0 : 1)
        } else {
            
            /*
             Create the account. If we cannot create the account, then check if it is because the username was
             taken. If the username is taken, alert the user. If there was some other unkown error, then just exit the operation. If there were no
             errors, then switch screens and clean up this screen
             */
            ProfileSelection(isProfileSelecting: $isProfilePictureSelecting, isDisabled: $isDisabled){image in
                Map.createAccountWith(username, email, password, name, image){success in
                    if(success){
                        Mixpanel.mainInstance().track(event: "Profile Picture Selection", properties: [
                        
                            "success": true
                        
                        ])
                        withAnimation(){
                            isCreateAccount = false
                            isLogin = true
                            username = ""
                            password = ""
                            name = ""
                            email = ""
                        }
                    } else{
                        Mixpanel.mainInstance().track(event: "Profile Picture Selection", properties: [
                        
                            "success": false
                        
                        ])
                        alertState = .emailTaken
                        isAlertPresented = true
                        isProfilePictureSelecting.toggle()
                    }
                    
                }
                
            }
            .opacity(isProfilePictureSelecting ? 1 : 0)
            
        }
    }
    

    
}

enum createAccountAlert{
    case usernameTaken,
         passwordShort,
         usernameFieldEmpty,
         emailFieldEmpty,
         unknownError,
         emailTaken,
         waiting
}






