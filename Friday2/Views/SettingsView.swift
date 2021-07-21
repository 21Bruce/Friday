//
//  SettingsView.swift
//  Saturday
//
//  Created by George Heisel on 7/14/21.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        VStack(alignment: .trailing){
            ZStack{
                HStack{
                    HStack{
                    Image(systemName: "gear")
                    Text("Settings")
                        .font(.custom("Avenir Medium", size: 20))
                    }
                    .padding(.horizontal)
                    Spacer()
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                            .frame(width: 30, height: 30)
                    })
                    .buttonStyle(BorderlessButtonStyle())
                }
                    }
            ScrollView() {
                    VStack(alignment: .leading, spacing:0){
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            ZStack{
                                Rectangle()
                                .stroke()
                                    .foregroundColor(Color(red: 200/255, green: 200/255, blue: 200/255)
                            )
                                    .frame(maxWidth:.infinity)
                                HStack{
                            Image(systemName: "camera.circle.fill")
                                .foregroundColor(.black)
                            Text("Change Profile Picture")
                                .font(.custom("Avenir Medium", size: 18)) 
                                .foregroundColor(.black)
                                    Image(systemName: "arrow.right")
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                                .padding(10)
                        }
                        })
                .buttonStyle(BorderlessButtonStyle())
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            ZStack{
                                Rectangle()
                                .stroke()
                                    .foregroundColor(Color(red: 200/255, green: 200/255, blue: 200/255)
                            )
                                    .frame(maxWidth:.infinity)
                                HStack{
                            Image(systemName: "bell")
                                .foregroundColor(.black)
                            Text("Notifications")
                                .font(.custom("Avenir Medium", size: 18))
                                .foregroundColor(.black)
                                    Image(systemName: "arrow.right")
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                                .padding(10)
                        }
                        })
                .buttonStyle(BorderlessButtonStyle())
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            ZStack
                            {
                                Rectangle()
                                .stroke()
                                    .foregroundColor(Color(red: 200/255, green: 200/255, blue: 200/255)
                            )
                                    .frame(maxWidth:.infinity)
                                HStack{
                            Image(systemName: "person.badge.minus")
                                .foregroundColor(.black)
                            Text("Sign Out")
                                .font(.custom("Avenir Medium", size: 18))
                                .foregroundColor(.black)
                                    Image(systemName: "arrow.right")
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                                .padding(10)
                        }
                        })
                        .buttonStyle(BorderlessButtonStyle())
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            ZStack
                            {
                                Rectangle()
                                .stroke()
                                    .foregroundColor(Color(red: 200/255, green: 200/255, blue: 200/255)
                            )
                                    .frame(maxWidth:.infinity)
                                HStack{
                            Image(systemName:"rectangle.fill.on.rectangle.fill")
                                .foregroundColor(.black)
                            Text("Change Background")
                                .font(.custom("Avenir Medium", size: 18))
                                .foregroundColor(.black)
                                    Image(systemName: "arrow.right")
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                                .padding(10)
                        }
                        })
                        .buttonStyle(BorderlessButtonStyle())
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            ZStack
                            {
                                Rectangle()
                                .stroke()
                                    .foregroundColor(Color(red: 200/255, green: 200/255, blue: 200/255)
                            )
                                    .frame(maxWidth:.infinity)
                                HStack{
                            Image(systemName:"questionmark.circle.fill")
                                .foregroundColor(.black)
                            Text("Help")
                                .font(.custom("Avenir Medium", size: 18))
                                .foregroundColor(.black)
                                    Image(systemName: "arrow.right")
                                        .foregroundColor(.black)
                                    Spacer()
                                }
                                .padding(10)
                        }
                        })
                        .buttonStyle(BorderlessButtonStyle())
                        
            }
        }
    }
}
}

    
    
    
    
    
    
    
    
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
