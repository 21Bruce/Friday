//
//  PlanView.swift
//  Friday2
//
//  Created by Bruce Jagid on 7/18/21.
//

import SwiftUI
import Mixpanel



struct PlanView: View {
    
    
    let CLimit = 25
    @EnvironmentObject var Map: UserSocialMap
    @Binding var isPlanPlanning: Bool
    @Binding var planSuccess: Bool
    @State var date = Date()
    @State var address = ""
    @State var description = "" {
        didSet{
            if description.count > CLimit {
                description = String(description.prefix(CLimit))
            }
    }
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
        ZStack{
            RoundedRectangle(cornerRadius: 25)
                .foregroundColor(.white)
                .frame(width: 370, height: 500, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            VStack{
                DatePicker(
                        "Start Date",
                        selection: $date,
                        in: dateRange,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                .datePickerStyle(GraphicalDatePickerStyle())
                .frame(width: 300, height: 300, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                HStack{
                    Text("Description:")
                        .frame(width: 100)
                    TextField("What are you planning?", text: $description)
                        .frame(width: 300, height: 30)
                }
                .offset(CGSize(width: 35, height: 20))
                HStack{
                    Text("Location:")
                    TextField("Enter Address", text: $address).frame(width: 300, height: 30)
                }
                .offset(CGSize(width: 40, height: 40))
               
            }
           
        }
        .onAppear(){
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: Date())
            print(hour)
        }
        .onChange(of: planSuccess){value in
            if(value){
                Mixpanel.mainInstance().track(event: "Plan Created")
                Map.setPlanDateAndLocation(at: address, on: date, with: description)
                Map.commitPlan()
                planSuccess.toggle()
                date = Date()
                address = ""
                description = ""
            }
            
        }
        .zIndex(isPlanPlanning ? 1 : 0)
        
    }
        
}


