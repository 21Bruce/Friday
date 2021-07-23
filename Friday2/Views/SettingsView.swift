//
//  SettingsView.swift
//  Saturday
//
//  Created by George Heisel on 7/14/21.
//

import SwiftUI

struct SettingsView: View {
    var SettingsTextPadding: CGFloat = 6
    var SettingsTextSize: CGFloat = 20
    var DividerColor: Color = Color(red: 200/255, green: 200/255, blue: 200/255)
    var DividerWidth: CGFloat = 1
    var SettingsColor: Color = Color(.black)
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 0){
            ZStack{
                HStack{
                    HStack{
                        Image(systemName: "gear")
                        Text("Settings")
                            .font(.custom("Avenir Medium", size: SettingsTextSize))
                    }
                    .foregroundColor(SettingsColor)
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
            .padding(.bottom, SettingsTextPadding)
            .padding(.top, SettingsTextPadding)
            CNiceDividers(Color: DividerColor, Width: DividerWidth)
            ScrollView() {
                VStack(alignment: .leading, spacing:0){
                    CNiceDividers(Color: DividerColor, Width: DividerWidth)
                    Button(action: {}, label: {
                        SettingTab(
                            IconImage: "camera.circle.fill",
                            SettingName: "Change Profile Picture"
                        )
                    })
                    .buttonStyle(BorderlessButtonStyle())
                    Button(action: {}, label: {
                        SettingTab(
                            IconImage: "bell",
                            SettingName: "Notifications"
                        )
                    })
                    .buttonStyle(BorderlessButtonStyle())
                    Button(action: {}, label: {
                        SettingTab(
                            IconImage: "person.badge.minus",
                            SettingName: "Sign Out"
                        )
                    })
                    .buttonStyle(BorderlessButtonStyle())
                    Button(action: {}, label: {
                        SettingTab(
                            IconImage: "rectangle.fill.on.rectangle.fill",
                            SettingName: "Change Background"
                        )
                    })
                    .buttonStyle(BorderlessButtonStyle())
                    Button(action: {}, label: {
                        SettingTab(
                            IconImage: "questionmark.circle.fill",
                            SettingName: "Help"
                        )
                    })
                    .buttonStyle(BorderlessButtonStyle())
                }
            }

        }
    }
}

struct SettingTab: View {
    var DividerColor: Color = Color(red: 200/255, green: 200/255, blue: 200/255)
    var SettingFontSize: CGFloat = 18
    var SettingColor: Color = Color(.black)
    var PaddingSpace: CGFloat = 9
    var IconImage: String
    var SettingName: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack{
                Image(systemName: IconImage)
                Text(SettingName)
                    .font(.custom("Avenir Medium", size: SettingFontSize))
                Image(systemName: "arrow.right")
                Spacer()
            }
            .foregroundColor(SettingColor)
            .padding(.leading, PaddingSpace * 1.5)
            .padding(.bottom, PaddingSpace)
            CNiceDividers(Color: DividerColor, Width: 1)
        }
        .padding(.top, PaddingSpace)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

//MARK: Implementation Code

struct ModifiedSettingTab: View {
    var DividerColor: Color = Color(red: 200/255, green: 200/255, blue: 200/255)
    var SettingFontSize: CGFloat = 18
    var SettingColor: Color = Color(.black)
    var PaddingSpace: CGFloat = 9
    var IconImage: String
    var SettingName: String
    var Place: String
    
    
    var body: some View {
        Button(action: {
            //Navigation link to place under var Place
        },
        label: {
            VStack(spacing: 0) {
                HStack{
                    Image(systemName: IconImage)
                    Text(SettingName)
                        .font(.custom("Avenir Medium", size: SettingFontSize))
                    Image(systemName: "arrow.right")
                    Spacer()
                }
                .foregroundColor(SettingColor)
                .padding(.leading, PaddingSpace * 1.5)
                .padding(.bottom, PaddingSpace)
                CNiceDividers(Color: DividerColor, Width: 1)
            }
            .padding(.top, PaddingSpace)
        })
    }
}

//MARK: OLD CODE

        //        ZStack{
        //            Rectangle()
        //                .stroke()
        //                .foregroundColor(DividerColor)
        //                .frame(maxWidth:.infinity)
        //            HStack{
        //                Image(systemName: IconImage)
        //                    .foregroundColor(.black)
        //                Text(SettingName)
        //                    .font(.custom("Avenir Medium", size: SettingFontSize))
        //                    .foregroundColor(SettingColor)
        //                Image(systemName: "arrow.right")
        //                    .foregroundColor(SettingColor)
        //                Spacer()
        //            }
        //            .padding(10)
        //        }
            
        
