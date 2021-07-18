//
//  SocialMap.swift
//  Friday2
//
//  Created by Bruce Jagid on 7/18/21.
//


import SwiftUI
import CoreLocation
import UserNotifications



struct Level: Identifiable{
    
    var id: Int = 0
    var Contents: [Person] = []
    
}


struct Person: Identifiable, Equatable {
    static func == (lhs: Person, rhs: Person) -> Bool {
        lhs.id == rhs.id
    }
    
    var username: String = ""
    var plans: [String] = [String]()
    var friendInbox: [String:String] = [String:String]()
    var friends: [String:Int] = [String:Int]()
    var planInbox: [String:[String]] = [String:[String]]()
    var posts: [Int: String] = [Int: String]()
    var postsInbox: [String:String] = [String:String]()
    var postsStatus: [String:Bool] = [String:Bool]()
    var name: String = ""
    var id: String = ""
    var profilePic: UIImage = UIImage()
    var isProfileDownloaded: Bool = true
   
}


struct Plan: Identifiable, Equatable{
    
    static func == (lhs: Plan, rhs: Plan) -> Bool {
        lhs.id == rhs.id
    }
    
    var date: String = ""
    var id: String = ""
    var host: String = ""
    var red: Double = .random()
    var blue: Double = .random()
    var green: Double = .random()
    var users: [Person] = []
    var address: String = ""
    var description: String = ""
}


//MARK: Control Panel
let ScalingFactor: Int = 3
let DefaultCapacity: Int = 5
