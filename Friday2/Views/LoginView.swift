//
//  LoginView.swift
//  Friday2
//
//  Created by Bruce Jagid on 7/18/21.
//

import SwiftUI
import Mixpanel
import FirebaseAuth

struct LoginView: View {
    
    @EnvironmentObject var Map: UserSocialMap
    @State private var email = ""
    @State private var password = ""
    @State private var isUserNotFoundAlertPresented = false
    @Binding var isLogin: Bool
    @Binding var isCreateAccount: Bool
    @Binding var isMainScreen: Bool
    @State private var isChecked = false
    @State private var isDisabled = false
    @State private var isLogging = false
    
    var body: some View {
        Group{
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
                        Image(systemName: "person")
                        TextField("Email Address", text: $email)
                            .disabled(isDisabled)
                    }.padding()
                    
                }
                .frame(height: 45.0)
                .padding(.vertical)
                
                
                ZStack {
                    RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/).stroke()
                    
                    HStack {
                        Image(systemName: "lock")
                        TextField("Password", text: $password)
                            .disabled(isDisabled)
                    }.padding()
                    
                }
                .frame(height: 45.0)
                
                Text("Logging In...")
                    .font(.custom("avenir medium", size: 15))
                    .opacity(isLogging ? 1 : 0)
                    .padding()
                    .frame(height: 45.0)
                
                ZStack{
                    Toggle(isOn: $isChecked){
                        Text("Remember me")
                            .font(.subheadline)
                            .foregroundColor(Color.gray)
                    }
                    .disabled(isDisabled)
                }
                .padding(.top)
                
                ZStack {
                    RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.gray).frame(width:100, height: 50.0)
                    Button("Sign In"){
                        isDisabled = true
                        isLogging = true
                        Mixpanel.mainInstance().track(event: "Sign In")
                        withAnimation(){
                            Map.loginToAccount(email, password: password){success in
                                print(success)
                                withAnimation(){
                                    if(success){
                                        if(isChecked){
                                            let userDefaults = UserDefaults.standard
                                            userDefaults.setValue(email, forKey: "fridayEmailField")
                                            userDefaults.setValue(password, forKey: "fridayPasswordField")
                                        }
                                        email = ""
                                        password = ""
                                        isLogin = false
                                        isDisabled = false
                                        isMainScreen = true
                                        isLogging = false
                                        
                                    }else{
                                        isUserNotFoundAlertPresented = true
                                        isDisabled = false
                                        isLogging = false
                                    }
                                }
                            }
                        }
                        
                        
                    }
                    .disabled(isDisabled)
                    .foregroundColor(.black)
                }
                .alert(isPresented: $isUserNotFoundAlertPresented, content: {
                    Alert(title: Text("User Not Found"), message: Text("The email and password pair entered does not match an account, please try again with new login credentials"), dismissButton: .default(Text("Ok")))
                })
                .padding(.top)
                
                ZStack {
                    RoundedRectangle(cornerRadius: /*@START_MENU_TOKEN@*/25.0/*@END_MENU_TOKEN@*/)
                        .foregroundColor(.gray).frame(width: 200, height: 50.0)
                    Button("Go To Create Account") {
                        Mixpanel.mainInstance().track(event: "Account Creation Started")
                        withAnimation(){
                            isLogin = false
                            isCreateAccount = true
                        }
                        
                    }
                    .disabled(isDisabled)
                    .foregroundColor(.black)
                }
                
                
                
                
            }
            .frame(width: 210.0)
        }.onAppear(){
            let userDefaults = UserDefaults.standard
            
            if let storedEmail = userDefaults.string(forKey: "fridayEmailField"){
                if let storedPassword = userDefaults.string(forKey: "fridayPasswordField"){
                    isDisabled = true
                    isLogging = true
                    Map.loginToAccount(storedEmail, password: storedPassword){success in
                        print(success)
                        withAnimation(){
                            if(success){
                                email = ""
                                password = ""
                                isLogin = false
                                isDisabled = false
                                isMainScreen = true
                                isLogging = false
                                
                            }else{
                                isUserNotFoundAlertPresented = true
                                isDisabled = false
                                isLogging = false
                            }
                        }
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
    
    
    
}


