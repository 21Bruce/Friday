//
//  SuggestTime.swift
//  Friday2
//
//  Created by George Heisel on 7/19/21.
//

import SwiftUI

struct SuggestTime: View {
    @EnvironmentObject var Map: UserSocialMap
    @State var newDate = Date()
    @Binding private var showPopover : Bool
    init(showPopover: Binding<Bool>) {
        _showPopover = showPopover
    }
    let dateRange: ClosedRange<Date> = {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: Date())
        let minutes = calendar.component(.minute, from: Date())
        let day = calendar.component(.day, from: Date())
        let month = calendar.component(.month, from: Date())
        let startComponents = DateComponents(year: 2021, month: month, day: day, hour: hour, minute: minutes)
        let endComponents = DateComponents(year: 2021, month: month, day: day.advanced(by: 7), hour: 23, minute: 59)
        return calendar.date(from:startComponents)! ... calendar.date(from:endComponents)!
    }()


    var body: some View {
        Color(.white)
        VStack{
            HStack{
                Spacer()
            ExitButton(onSubmit: {showPopover = false})
                .frame(width: 30, height: 30)
            }
            .padding(10)
        ZStack{
            RoundedRectangle(cornerRadius: 25.0)
                .stroke()
                .foregroundColor(.black)
                .frame(height: 400)
                .padding(10)
            VStack{
                DatePicker(
                        "Start Date",
                        selection: $newDate,
                        in: dateRange,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                .datePickerStyle(GraphicalDatePickerStyle())
                .frame(width: 300, height: 300)
}
           
        }
            Spacer()
            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                ZStack{
                GrayRoundedButton()
                    Text("Suggest a Reschedule")
                        .font(.custom("Avenir Medium", size: 18))
                        .foregroundColor(.black)
                }
            })
            .buttonStyle(BorderlessButtonStyle())
            .frame(height:60)
        }
    }
}
