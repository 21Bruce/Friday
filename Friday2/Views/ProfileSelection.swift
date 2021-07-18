//
//  ProfileSelection.swift
//  Friday2
//
//  Created by Bruce Jagid on 7/18/21.
//

import SwiftUI

struct ProfileSelection: View {
    @State var profileImage: UIImage? = nil
    @State var imagePicker: Bool = false
    @State var createAccount: (UIImage) -> Void
    @Binding var isDisabled: Bool
    @Binding var isProfileSelecting: Bool
    
    init(isProfileSelecting: Binding<Bool>, isDisabled: Binding<Bool>, createAccount: @escaping (UIImage) -> Void){
        self.createAccount = createAccount
        _isProfileSelecting = isProfileSelecting
        _isDisabled = isDisabled
    }
    
    var body: some View {
        
        ZStack{
            Image(uiImage: profileImage ?? UIImage())
                .resizable()
                .clipShape(Circle())
                .opacity(profileImage == nil ? 0 : 1)
                .frame(width: 150, height: 200, alignment: .center)
                .onTapGesture {
                    imagePicker.toggle()
                }
            
            GeometryReader{geometry in
                Text("Select a profile picture")
                    .font(.custom("Avenir Medium", size: 30))
                    .position(x: geometry.size.width/2, y: 20)
            }
            
            
            Circle()
                .stroke(lineWidth: 4)
                .opacity(0.8)
                .frame(width: 150, height: 150, alignment: .center)
            Group{
                Circle()
                    .foregroundColor(.yellow)
                    .opacity(0.1)
                    .frame(width: 150, height: 150, alignment: .center)
                
                Text("Tap To Select")
                    .opacity(0.3)
                    .font(.custom("Avenir Medium", size: 20))
                    .foregroundColor(.gray)
                    .frame(width: 150, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
            .opacity(profileImage == nil ? 1 : 0)
            .onTapGesture {
                imagePicker.toggle()
            }
            
            
            GeometryReader{geometry in
                Text("In-App Preview")
                    .font(.custom("Avenir Medium", size: 17))
                    .position(x: geometry.size.width/2, y: geometry.size.height/1.6)
                
                Button(action: {
                        isDisabled = false
                        createAccount(profileImage!)}, label: {
                    ZStack{
                        
                        RoundedRectangle(cornerRadius: 25.0)
                            .foregroundColor(Color(red: 0.9254901960784314, green: 0.7686274509803922, blue: 0.8))
                            .frame(width: 100, height: 50, alignment: .center)
                        
                        Text("Confirm")
                            .font(.custom("Avenir Medium", size: 17))
                            .foregroundColor(.black)
                    }
                    .scaleEffect(1.2)
                    
                })
                .position(x: geometry.size.width/1.2, y: geometry.size.height/1.03)
                .opacity(profileImage == nil ? 0 : 1)
                
                Button(action: {withAnimation(){
                        isDisabled = false
                        isProfileSelecting = false
                    
                }}, label: {
                    ZStack{
                        
                        RoundedRectangle(cornerRadius: 25.0)
                            .foregroundColor(Color(red: 0.9254901960784314, green: 0.7686274509803922, blue: 0.8))
                            .frame(width: 100, height: 50, alignment: .center)
                        
                        Text("Go Back")
                            .font(.custom("Avenir Medium", size: 17))
                            .foregroundColor(.black)
                    }
                    .scaleEffect(1.2)
                    
                })
                .position(x: geometry.size.width/6, y: geometry.size.height/1.03)
            }
            
            
        }
        .sheet(isPresented: $imagePicker, content: {
            PhotoLibrary(isPresented: $imagePicker, img: $profileImage)
        })
        
    }
    
}


