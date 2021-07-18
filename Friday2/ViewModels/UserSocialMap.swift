//
//  UserSocialMap.swift
//  Friday2
//
//  Created by Bruce Jagid on 7/18/21.
//

import SwiftUI
import Foundation
import CoreLocation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth


class UserSocialMap: ObservableObject {
    
    @Published private(set) var PlanInMaking: Plan = Plan()
    
    @Published private(set) var mainUser: Person = Person()
    
    @Published private(set) var levels: [Level] = [Level](repeating: Level(), count: 3)
    
    @Published private(set) var plans: [Plan] = [Plan]()
    
    @Published private(set) var friendInfo: [Person] = []
    
    private var downloadedPics: [String:UIImage] = [:]
    
    private var planIDList: [String] {
        mainUser.plans
    }
    
    private var friends: [String:Int] {
        mainUser.friends
    }
    
    var friendInbox: [String:String] {
        mainUser.friendInbox
    }
    
    var planInboxIDs: [String] {
        return Array(mainUser.planInbox.keys)
    }
    
    var planInboxRawData: [String:[String]]{
        self.mainUser.planInbox
    }
    
    var postsInbox: [String:String]{
        self.mainUser.postsInbox
    }
    
    var postsStatus: [String:Bool]{
        self.mainUser.postsStatus
    }
    
    var myPosts: [String]{
        var postDisplayable = [String](repeating: String(), count: self.mainUser.posts.count)
        for i in 0..<postDisplayable.count{
            postDisplayable[i] = self.mainUser.posts[i]!
        }
        return postDisplayable
    }
    
    
    
    func getPlanIDFromDisplayData(_ displayData: [String]) -> String?{
        for (key, value) in mainUser.planInbox{
            if value == displayData{
                return key
            }
            
        }
        
        print("nil")
        
        return nil
        
    }
    
    
    func getFriendUsernameWithID(_ id: String) -> String?{
        for user in self.friendInfo{
            if user.id == id{
                return user.username
            }
        }
        return nil
    }
    
    
    func isUserInLevel(_ User: Person, in Level: Level) -> Bool{
        for person in Level.Contents{
            if person.id == User.id{
                return true
            }
        }
        return false
    }
    
    
    
    func userLevel(_ User: Person) -> Level?{
        for level in levels{
            for user in level.Contents{
                if user.id == User.id{
                    return level
                }
            }
        }
        return nil
    }
    
    func getUsersFromCurrentPlan() -> [Person]{
        
        return PlanInMaking.users
    }
    
    
    
    
    //MARK: Intents -
    
    
    func setPlanDateAndLocation(at address: String, on date: Date, with description: String){
        
        let rawDate = date.localizedDate.description
        let removedTag = rawDate.replacingOccurrences(of: " +0000", with: "")
        PlanInMaking.date = removedTag
        PlanInMaking.address = address
        PlanInMaking.description = description
    }
    
    
    func addUserToPlan(_ User: Person){
        
        PlanInMaking.users.append(User)
    }
    
    func removeUserFromPlan(_ User: Person){
        
        let UserPosition = GetFirstPosition(User, in: PlanInMaking.users)!
        PlanInMaking.users.remove(at: UserPosition)
        
    }
    
    //Execute a completion here if necessary
    func commitPlan(){
        
        sendPlan()
        
    }
    
    func destroyPlan(){
        
        PlanInMaking = Plan()
    }
    
    
    //MARK: Back-End -
    //WARNING: Shit gets wild past this point
    
    private let store = Firestore.firestore()
    
    private let storage = Storage.storage()
    
    private let userPath = "users"
    
    private let planPath = "plans"
    
    
    func moveUser(_ User: Person, from level1: Level, to level2: Level, completion: @escaping (_ success: Bool) -> Void = {_ in }){
        
        self.levels[level1.id - 1].Contents.remove(at: GetFirstPosition(User, in: level1.Contents)!)
        self.levels[level2.id - 1].Contents.append(User)
        
        
        let userDB = store.collection(userPath)
        let userID = User.id
        
        userDB.document(self.mainUser.id + "/~r~w/privateAccountInfo").getDocument(){ (querySnapshot, err) in
            
            if let error = err{
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            guard let friendData = querySnapshot!.data() else{
                completion(false)
                return
            }
            
            guard var friends = friendData["friends"] as? [String:Int] else{
                completion(false)
                return
            }
            
            friends[userID] = level2.id
            
            userDB.document(self.mainUser.id + "/~r~w/privateAccountInfo").updateData([
                
                "friends":friends
                
                
            ])
            
            completion(true)
            return
            
        }
    }
    
    
    func createAccountWith(_ username: String, _ email: String, _ password: String, _ name: String, _ img: UIImage, completion: @escaping (_ success: Bool) -> Void) {
        let userDB = store.collection(userPath)
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        let ref = storage.reference()
        
        Auth.auth().createUser(withEmail: email, password: password){ (authResult, err) in
            if let error = err{
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            guard authResult != nil else{
                print("Error authenticating, user not created")
                completion(false)
                return
            }
            
            Auth.auth().signIn(withEmail: email, password: password){ (authResult, err) in
                if let error = err{
                    print(error.localizedDescription)
                    completion(false)
                    return
                }
                
                guard let result = authResult else{
                    print("Error authenticating, user not created")
                    completion(false)
                    return
                }
                
                let user = result.user
                let id = user.uid
                
                userDB.document(id).setData([
                    "username":username,
                    "name":name
                ])
                
                userDB.document(id + "/~r~w/privateAccountInfo").setData([
                    
                    "friends": [String:Int](),
                    "deviceToken": String(),
                    "plans": [String]()
                    
                    
                ])
                
                userDB.document(id + "/~r~w/friendInboxes").setData([
                    
                    "planInbox": [String:[String]](),
                    "postsInbox": [String: String](),
                    "postsRead": [String: Bool](),
                    "trustedAuths": [String]()
                    
                ])
                
                userDB.document(id + "/~rw/publicInboxes").setData([
                    
                    "friendInbox":  [String:String]()
                    
                ])
                
                guard let imgData: Data = img.jpegData(compressionQuality: 0.2) else {
                    print("Could not get user image data")
                    completion(false)
                    return
                }
                
                let refToUser = ref.child("profilePictures/" + id + "/profile.jpg")
                
                
                refToUser.putData(imgData, metadata: metaData){(metaData, err) in
                    if let error = err{
                        print(error.localizedDescription)
                        completion(false)
                        return
                    }
                }
                
                completion(true)
                return
                
            }
        }
        
        
        
    }
    
    func loginToAccount(_ email: String, password: String, completion: @escaping (_ success: Bool) -> Void){
        let userDB = store.collection(userPath)
        let metaData = StorageMetadata()
        metaData.contentType = "image/png"
        let ref = storage.reference()
        
        levels[0].id = 1
        levels[1].id = 2
        levels[2].id = 3
        
        Auth.auth().signIn(withEmail: email, password: password){(authResult, err) in
            if let error = err{
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            guard let result = authResult else{
                print("Error authenticating, user not created")
                completion(false)
                return
            }
            let id = result.user.uid
            
            self.mainUser.id = id
            
            userDB.document(id + "/~r~w/privateAccountInfo").updateData([
                
                "deviceToken":deviceTokenString
                
            ])
            
            let refToThisUser = ref.child("profilePictures/" + id + "/profile.jpg")
            
            refToThisUser.getData(maxSize: 1 * 2048 * 2048){data, err in
                if let error = err{
                    print(error.localizedDescription)
                    completion(false)
                    return
                }
                
                self.mainUser.profilePic = UIImage(data: data!)!
                
                print("phase 1")
                
                userDB.document(id + "/~r~w/privateAccountInfo").getDocument(){(documentSnapshot, err) in
                    print("phase 2")
                    if let error = err{
                        print(error.localizedDescription)
                        completion(false)
                        return
                    }
                    
                    guard let data = documentSnapshot!.data() else{
                        print("Could not access main user document")
                        completion(false)
                        return
                    }
                    
                    guard let friends = data["friends"] as? [String:Int] else{
                        print("Could not access main user friends")
                        completion(false)
                        return
                    }
                    
                    
                    
                    let friendIDList = Array(friends.keys)
                    
                    
                    print("end Phase 2")
                    self.downloadProfilePictures(idList: friendIDList, CurrentPosition: 0){
                        print("phase 3")
                        userDB.document(id + "/~r~w/privateAccountInfo").addSnapshotListener(){(querySnapshot, err) in
                            
                            if let error = err {
                                print(error.localizedDescription)
                                completion(false)
                                return
                            }
                            
                            guard let userDictionary = querySnapshot!.data() else{
                                completion(false)
                                return
                            }
                            
                            self.mainUser.friends = userDictionary["friends"] as? [String:Int] ?? [:]
                            self.mainUser.plans = userDictionary["plans"] as? [String] ?? []
                            self.friendInfo = [Person](repeating: Person(), count: self.mainUser.friends.count)
                            self.plans = [Plan](repeating: Plan(), count: self.mainUser.plans.count)
                            
                            
                            print("end Phase 3")
                            self.listenToFriends(idList: Array(self.mainUser.friends.keys), CurrentPosition: 0) {result in
                                print("phase 4")
                                guard result else{
                                    print("Could not listen to friends")
                                    completion(false)
                                    return
                                }
                                
                                //if we can listen to friends, then begin filling our levels
                                var tmpLevels = [Level](repeating: Level(), count: 3)
                                tmpLevels[0].id = 1
                                tmpLevels[1].id = 2
                                tmpLevels[2].id = 3
                                for user in self.friendInfo{
                                    let ringPositionFromOne = self.friends[user.id] ?? 1
                                    tmpLevels[ringPositionFromOne-1].Contents.append(user)
                                    tmpLevels[ringPositionFromOne-1].id = ringPositionFromOne
                                }
                                self.levels = tmpLevels
                                
                                self.listenToPlans(idList: Array(self.mainUser.plans), CurrentPosition: 0){success in
                                    guard result else{
                                        print("Could not listen to plans")
                                        completion(false)
                                        return
                                    }
                                    
                                    userDB.document(id).addSnapshotListener(){(querySnapshot, err) in
                                        if let error = err {
                                            print(error.localizedDescription)
                                            completion(false)
                                            return
                                        }
                                        
                                        guard let userDictionary = querySnapshot!.data() else{
                                            completion(false)
                                            return
                                        }
                                        
                                        self.mainUser.username = userDictionary["username"] as? String ?? "USERNAME_NOT_FOUND"
                                        self.mainUser.name = userDictionary["name"] as? String ?? "NAME_NOT_FOUND"
                                        
                                        
                                        userDB.document(id + "/~rw/publicInboxes").addSnapshotListener(){(querySnapshot, err) in
                                            if let error = err {
                                                print(error.localizedDescription)
                                                completion(false)
                                                return
                                            }
                                            
                                            guard let userDictionary = querySnapshot!.data() else{
                                                completion(false)
                                                return
                                            }
                                            
                                            self.mainUser.friendInbox = userDictionary["friendInbox"] as? [String:String] ?? [:]
                                            
                                            userDB.document(id + "/~r~w/friendInboxes").addSnapshotListener(){(querySnapshot, err) in
                                                if let error = err {
                                                    print(error.localizedDescription)
                                                    completion(false)
                                                    return
                                                }
                                                
                                                guard let userDictionary = querySnapshot!.data() else{
                                                    completion(false)
                                                    return
                                                }
                                                
                                                
                                                self.mainUser.planInbox = userDictionary["planInbox"] as? [String:[String]] ?? [:]
                                                self.mainUser.postsInbox = userDictionary["postsInbox"] as? [String: String] ?? [:]
                                                self.mainUser.postsStatus = userDictionary["postsRead"] as? [String: Bool] ?? [:]
                                                
                                                completion(true)
                                                return
                                                
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func downloadProfilePictures(idList: [String], CurrentPosition: Int, completion: @escaping () -> Void = {}){
        
        guard !idList.isEmpty else{
            completion()
            return
        }
        
        guard CurrentPosition < idList.count else{
            completion()
            return
        }
        let metaData = StorageMetadata()
        metaData.contentType = "images/png"
        let ref = self.storage.reference()
        let refToFriend = ref.child("profilePictures/" + idList[CurrentPosition] + "/profile.jpg")
        
        refToFriend.getData(maxSize: 1 * 2048 * 2048){data, err in
            if let error = err{
                print(error.localizedDescription)
                self.downloadProfilePictures(idList: idList, CurrentPosition: CurrentPosition+1){
                    completion()
                }
                return
            }
            
            self.downloadedPics[idList[CurrentPosition]] = UIImage(data: data!)!
            self.downloadProfilePictures(idList: idList, CurrentPosition: CurrentPosition+1){
                completion()
            }
            
            
        }
    }
    
    
    
    //recursive completion handler for querying friend data
    private func listenToFriends(idList: [String], CurrentPosition: Int, completion: @escaping (_ result: Bool) -> Void){
        
        guard !idList.isEmpty else{
            completion(true)
            return
        }
        
        let userDB = store.collection(userPath)
        
        
        guard CurrentPosition < idList.count else{
            completion(true)
            return
        }
        
        guard !(idList[CurrentPosition] == "") else{
            completion(false)
            return
        }
        
        userDB.document(idList[CurrentPosition]).addSnapshotListener(){ (querySnapshot, err) in
            if let error = err{
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            guard let data = querySnapshot!.data() else{
                completion(false)
                return
            }
            
            
            
            self.friendInfo[CurrentPosition].username = data["username"] as? String ?? ""
            self.friendInfo[CurrentPosition].name = data["name"] as? String ?? ""
            self.friendInfo[CurrentPosition].id = idList[CurrentPosition]
            self.friendInfo[CurrentPosition].profilePic = self.downloadedPics[self.friendInfo[CurrentPosition].id]!
            
            
            
            
            
            self.listenToFriends(idList: idList, CurrentPosition: CurrentPosition + 1){success in
                completion(success)
            }
            
            
        }
        
        
        
        
    }
    
    
    
    //recursive completion handler for querying plan data
    private func listenToPlans(idList: [String], CurrentPosition: Int, completion: @escaping (_ success: Bool) -> Void){
        
        guard !idList.isEmpty else{
            completion(true)
            return
        }
        
        guard CurrentPosition < idList.count else{
            completion(true)
            return
        }
        
        guard idList[CurrentPosition] != "" else{
            completion(false)
            return
        }
        
        let planDB = store.collection(planPath)
        
        
        planDB.document(idList[CurrentPosition]).addSnapshotListener(){(querySnapshot, err) in
            
            if let error = err{
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            guard let data = querySnapshot!.data() else{
                completion(false)
                return
            }
            
            
            self.plans[CurrentPosition].red = data["red"] as? Double ?? 0
            self.plans[CurrentPosition].green = data["green"] as? Double ?? 0
            self.plans[CurrentPosition].blue = data["blue"] as? Double ?? 0
            self.plans[CurrentPosition].description = data["description"] as? String ?? ""
            self.plans[CurrentPosition].date = data["date"] as? String ?? ""
            self.plans[CurrentPosition].address = data["address"] as? String ?? ""
            self.plans[CurrentPosition].host = data["host"] as? String ?? ""
            self.plans[CurrentPosition].id = data["id"] as? String ?? ""
            
            let users = data["participants"] as? [String:String] ?? [:]
            let userIDList = Array(users.keys)
            
            self.listenToPlans(idList: idList, CurrentPosition: CurrentPosition + 1){success in
                guard success else{
                    completion(success)
                    return
                }
                
                self.getParticipantUsernames(idList: userIDList, CurrentPosition: 0){success, usernameList in
                    if(success){
                        for username in usernameList {
                            var user = Person()
                            user.username = username
                            self.plans[CurrentPosition].users.append(user)
                        }
                        completion(success)
                        return
                    }
                    
                    completion(success)
                    return
                    
                }
            }
            
        }
    }
    
    
    func sendFriendRequest(_ username: String, completion: @escaping (_ result: UserFriendRequestCompletion) -> Void){
        let userDB = store.collection(userPath)
        let usernameCheckQuery = userDB.whereField("username", isEqualTo: username)
        
        
        print("sendfriendRequest method called")
        usernameCheckQuery.getDocuments() {(querySnapshot, err) in
            if let error = err{
                print(error.localizedDescription)
                completion(.userIsYou)
                return
            }
            print("got past query")
            guard !(querySnapshot?.isEmpty ?? true) else{
                completion(.userNotFound)
                return
            }
            
            guard username != self.mainUser.username else{
                completion(.userIsYou)
                return
            }
            
            let friendID = querySnapshot!.documents.first!.reference.documentID
            
            guard !(self.mainUser.friends.keys.contains(friendID)) else{
                completion(.userInFriends)
                return
            }
            
            let metaData = StorageMetadata()
            metaData.contentType = "images/png"
            let ref = self.storage.reference().child("profilePictures/" + friendID + "/profile.jpg")
            
            ref.getData(maxSize: 1 * 2048 * 2048){data, err in
                print("picture downloading started")
                if let error = err{
                    print(error.localizedDescription)
                    completion(UserFriendRequestCompletion.unkownError)
                    return
                }
                print("got pic download")
                self.downloadedPics[friendID] = UIImage(data: data!)!
                
                userDB.document(friendID + "/~rw/publicInboxes").getDocument(){(documentSnapshot, err) in
                    print("input to friendInbox started")
                    let friendDictionary = documentSnapshot!.data()!
                    var friendInbox = friendDictionary["friendInbox"] as? [String:String] ?? [:]
                    
                    guard !(friendInbox.keys.contains(self.mainUser.id)) else{
                        completion(.requestAlreadyPending)
                        return
                    }
                    
                    friendInbox[self.mainUser.username] = self.mainUser.id
                    
                    userDB.document(friendID + "/~rw/publicInboxes").updateData(["friendInbox":friendInbox])
                    print("input to friendInbox passed")
                    
                    userDB.document(self.mainUser.id + "/~r~w/friendInboxes").getDocument(){(documentSapshot, err) in
                        print("input to trusted auths began")
                        if let error = err{
                            print(error.localizedDescription)
                            completion(UserFriendRequestCompletion.unkownError)
                            return
                        }
                        
                        guard let data = documentSapshot!.data() else{
                            completion(UserFriendRequestCompletion.unkownError)
                            return
                        }
                        
                        var trustedAuths = data["trustedAuths"] as? [String] ?? []
                        trustedAuths.append(friendID)
                        userDB.document(self.mainUser.id + "/~r~w/friendInboxes").updateData([
                            
                            "trustedAuths":trustedAuths
                            
                        ])
                        print("input to trusted auths completed")
                        
                        completion(.success)
                    }
                    
                    
                }
            }
        }
    }
    
    
    func acceptFriendRequest(from username: String, with friendID: String, completion: @escaping (_ success: Bool) -> Void = {_ in }){
        let userDB = store.collection(userPath)
        
        print("acceptFriendReuqest friend id:" + friendID)
        let metaData = StorageMetadata()
        metaData.contentType = "images/png"
        let ref = self.storage.reference().child("profilePictures/" + friendID + "/profile.jpg")
        
        ref.getData(maxSize: 1 * 2048 * 2048){data, err in
            if let error = err{
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            self.downloadedPics[friendID] = UIImage(data: data!)!
            
            userDB.document(self.mainUser.id + "/~r~w/privateAccountInfo").getDocument(){documentSnapshot, err in
                if let error = err{
                    print(error.localizedDescription)
                    completion(false)
                    return
                }
                
                guard let data = documentSnapshot!.data() else{
                    completion(false)
                    return
                }
                
                
                
                var myFriends = data["friends"] as? [String:Int] ?? [:]
                myFriends[friendID] = 3
                
                userDB.document(self.mainUser.id + "/~r~w/privateAccountInfo").updateData([
                    
                    "friends":myFriends
                    
                ])
                
                userDB.document(self.mainUser.id + "/~rw/publicInboxes").getDocument(){documentSnapshot, err in
                    let myData = documentSnapshot!.data()!
                    var myFriendInbox = myData["friendInbox"] as? [String:String] ?? [:]
                    
                    myFriendInbox.remove(at: myFriendInbox.index(forKey: username)!)
                    
                    userDB.document(self.mainUser.id + "/~rw/publicInboxes").updateData(
                        [
                            
                            "friendInbox":myFriendInbox
                            
                        ])
                    
                    userDB.document(friendID + "/~r~w/privateAccountInfo").getDocument() {(querySnapshot, err) in
                        if let error = err{
                            print(error.localizedDescription)
                            completion(false)
                            return
                        }
                        
                        guard querySnapshot?.exists ?? false else{
                            completion(false)
                            return
                        }
                        
                        let friendDictionary = querySnapshot!.data()!
                        var friendFriends = friendDictionary["friends"] as? [String:Int] ?? [:]
                        friendFriends[self.mainUser.id] = 3
                        
                        userDB.document(friendID + "/~r~w/privateAccountInfo").updateData(
                            [
                                
                                "friends":friendFriends
                                
                            ])
                        
                        let id = self.mainUser.id
                        
                        userDB.document(id + "/~r~w/friendInboxes").updateData([
                            
                            
                            "trustedAuths":FieldValue.arrayUnion([friendID])
                            
                        ])
                        
                        
                        completion(true)
                        
                        
                        
                    }
                }
            }
            
        }
    }
    
    func denyFriendRequest(from username: String,  with friendID: String){
        let userDB = store.collection(userPath)
        userDB.document(self.mainUser.id + "/~rw/publicInboxes").getDocument(){documentSnapshot, err in
            print("acceptfriendrequest remove from  my friendinbox")
            let myData = documentSnapshot!.data()!
            var myFriendInbox = myData["friendInbox"] as? [String:String] ?? [:]
            
            myFriendInbox.remove(at: myFriendInbox.index(forKey: username)!)
            
            userDB.document(self.mainUser.id + "/~rw/publicInboxes").updateData(
                [
                    
                    "friendInbox":myFriendInbox
                    
                ])
            
            let id = self.mainUser.id
            
            userDB.document(friendID + "/~r~w/friendInboxes").updateData([
                
                
                "trustedAuths":FieldValue.arrayRemove([id])
                
            ])
            
        }
    }
    
    //Completed
    private func getParticipantUsernames(idList: [String], CurrentPosition: Int, completion: @escaping (_ success: Bool, _ usernameList: [String]) -> Void){
        guard CurrentPosition < idList.count else{
            completion(true, [])
            return
        }
        
        guard idList[CurrentPosition] != "" else{
            completion(false, [])
            return
        }
        
        let userDB = store.collection(userPath)
        
        userDB.document(idList[CurrentPosition]).getDocument(){(querySnapshot, err) in
            
            if let error = err{
                print(error.localizedDescription)
                completion(false, [])
                return
            }
            
            guard let data = querySnapshot!.data() else{
                completion(false, [])
                return
            }
            
            let username = data["username"] as? String ?? ""
            
            self.getParticipantUsernames(idList: idList, CurrentPosition: CurrentPosition + 1){success, usernameList in
                if(success){
                    var list = usernameList
                    list.append(username)
                    completion(true, list)
                    return
                }
                
                completion(false, [])
                return
                
            }
            
            
        }
        
        
    }
    
    
    func sendPlan(completion: @escaping (_ success: Bool) -> Void = {_ in}){
        let planDB = store.collection(planPath)
        let userDB = store.collection(userPath)
        let planID = UUID().uuidString
        PlanInMaking.id = planID
        
        let planDoc = planDB.document(planID)
        var users: [String] = []
        for user in PlanInMaking.users{
            users.append(user.id)
        }
        
        planDoc.setData([
            
            "host":self.mainUser.id,
            "asked":users,
            "id":PlanInMaking.id,
            "address":PlanInMaking.address,
            "date":PlanInMaking.date,
            "description":PlanInMaking.description,
            "red": PlanInMaking.red,
            "green": PlanInMaking.green,
            "blue": PlanInMaking.blue
            
            
        ])
        
        userDB.document(self.mainUser.id + "/~r~w/privateAccountInfo").getDocument(){(querySnapshot, err) in
            if let error = err{
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            guard let userData = querySnapshot!.data() else{
                completion(false)
                return
            }
            
            guard !self.PlanInMaking.users.isEmpty else{
                completion(false)
                return
            }
            
            var myPlans = userData["plans"] as? [String] ?? []
            myPlans.append(planID)
            
            
            
            userDB.document(self.mainUser.id + "/~r~w/privateAccountInfo").updateData([
                
                "plans":myPlans
                
            ])
            
            
            
            self.writePlanToFriends(CurrentPosition: 0){success in
                completion(success)
                return
            }
            
        }
        
        
    }
    
    private func writePlanToFriends(CurrentPosition: Int, completion: @escaping (_ success: Bool) -> Void){
        let userDB = store.collection(userPath)
        let users = PlanInMaking.users
        
        guard CurrentPosition < PlanInMaking.users.count else{
            completion(true)
            return
        }
        
        guard !(users[CurrentPosition].id == "") else{
            completion(false)
            return
        }
        
        userDB.document(users[CurrentPosition].id + "/~r~w/friendInboxes").getDocument(){(querySnapshot, err) in
            if let error = err{
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            guard let userdata = querySnapshot!.data() else{
                completion(false)
                return
            }
            
            var userPlanInbox = userdata["planInbox"] as? [String:[String]] ?? [:]
            
            userPlanInbox[self.PlanInMaking.id] = [self.mainUser.id, self.PlanInMaking.description, self.PlanInMaking.date, self.PlanInMaking.address]
            
            userDB.document(users[CurrentPosition].id + "/~r~w/friendInboxes").updateData([
                
                "planInbox": userPlanInbox
                
            ])
            
            self.writePlanToFriends(CurrentPosition: CurrentPosition + 1){success in
                completion(success)
            }
            
            
            
        }
        
    }
    
    func acceptPlanRequest(_ planID: String, completion: @escaping (_ success: Bool) -> Void = {_ in}){
        let userDB = store.collection(userPath)
        let planDB = store.collection(planPath)
        
        let id = self.mainUser.id
        
        userDB.document(id + "/~r~w/friendInboxes").getDocument(){(documentSnapshot, err) in
            if let error = err{
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            guard let data = documentSnapshot!.data() else{
                print("Error: failed getting my data")
                completion(false)
                return
            }
            
            var myPlanInbox = data["planInbox"] as? [String:[String]] ?? [:]
            myPlanInbox.removeValue(forKey: planID)
            
            userDB.document(self.mainUser.id + "/~r~w/friendInboxes").updateData(
                [
                    
                    "planInbox": myPlanInbox
                ])
            
            userDB.document(self.mainUser.id + "/~r~w/privateAccountInfo").updateData(
                [
                    
                    "plans": FieldValue.arrayUnion([planID])
                    
                ]
            )
            
            planDB.document(planID).updateData(
                [
                    
                    "asked": FieldValue.arrayRemove([self.mainUser.id]),
                    "accepted":FieldValue.arrayUnion([self.mainUser.id])
                    
                ]
            )
            
            completion(true)
            return
            
        }
    }
    
    
    
    func rejectPlanRequest(_ planID: String, completion: @escaping (_ success: Bool) -> Void = {_ in}){
        let userDB = store.collection(userPath)
        let planDB = store.collection(planPath)
        
        let id = self.mainUser.id
        
        userDB.document(id + "/~r~w/friendInboxes").getDocument(){(documentSnapshot, err) in
            if let error = err{
                print(error.localizedDescription)
                completion(false)
                return
            }
            
            guard let data = documentSnapshot!.data() else{
                print("Error: failed getting my data")
                completion(false)
                return
            }
            
            var myPlanInbox = data["planInbox"] as? [String:[String]] ?? [:]
            myPlanInbox.removeValue(forKey: planID)
            
            
            userDB.document(self.mainUser.id + "/~r~w/friendInboxes").updateData(
                [
                    
                    "planInbox": myPlanInbox
                    
                ])
            
            
            planDB.document(planID).updateData(
                [
                    
                    "asked": FieldValue.arrayRemove([self.mainUser.id]),
                    "rejected": FieldValue.arrayUnion([self.mainUser.id])
                    
                ])
            
            completion(true)
            return
            
            
        }
        
    }
    
    func sendPost(_ post: String, to users: [Person], completion: @escaping (_ success: Bool) -> Void = {_ in}){
        
        guard !users.isEmpty else{
            completion(false)
            return
        }
        
        
        var idList: [String] = []
        
        for user in users{
            let id = user.id
            idList.append(id)
        }
        
        
        self.writePostToFriends(idList: idList, currentPosition: 0, post){success in
            completion(success)
        }
        
    }
    
    private func writePostToFriends(idList: [String], currentPosition: Int,  _ post: String, completion: @escaping (_ success: Bool) -> Void){
        let userDB = store.collection(userPath)
        
        guard currentPosition < idList.count else{
            completion(true)
            return
        }
        
        userDB.document(idList[currentPosition] + "/~r~w/friendInboxes").getDocument(){(querySnapshot,err) in
            if let error = err{
                print(error.localizedDescription)
                completion(false)
                return
            }
            guard let data = querySnapshot!.data() else{
                completion(false)
                return
            }
            
            var postsInbox = data["postsInbox"] as? [String:String] ?? [:]
            var postsStatus = data["postsStatus"] as? [String: Bool] ?? [:]
            postsInbox[self.mainUser.id] = post
            postsStatus[self.mainUser.id] = false
            
            
            userDB.document(idList[currentPosition] + "/~r~w/friendInboxes").updateData([
                
                "postsInbox": postsInbox
                
            ])
            
            self.writePostToFriends(idList: idList, currentPosition: currentPosition + 1, post){success in
                completion(success)
            }
            
            
        }
    }
    
    func checkUsername(_ username: String, completion: @escaping (_ success: Bool) -> Void){
        let userDB = store.collection(userPath)
        let userNameCheckQuery = userDB.whereField("username", isEqualTo: username)
        
        userNameCheckQuery.getDocuments(){(querySnapshot, err) in
            if let error = err{
                print(error.localizedDescription)
                completion(true)
                return
            }
            guard !querySnapshot!.isEmpty else{
                completion(true)
                return
            }
            
            completion(false)
            
        }
    }
    
    
}


enum userCreationCompletion{
    case usernameTaken,
         success,
         unkownError
}

enum userLoginCompletion{
    case userNotFound,
         success,
         unkownError
}

enum UserFriendRequestCompletion{
    case userInFriends,
         userNotFound,
         userIsYou,
         requestAlreadyPending,
         success,
         waiting,
         unkownError
}

