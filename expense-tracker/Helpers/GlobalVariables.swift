//
//  GlobalVariables.swift
//  expense-tracker
//
//  Created by Krish Mittal on 30/10/24.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class GlobalVariables: NSObject {
    
    static var shared = GlobalVariables()
    override  private init(){}
    
    class func reintiate(){
        GlobalVariables.shared = GlobalVariables()
    }
    
    
    let queue = DispatchQueue(label: "InternetConnectionMonitor")
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    
    var currentUser: ERUser? = UserDefaults().codableObject(dataType: ERUser.self, key: K.userData) {
        didSet {
            if let user = currentUser {
                UserDefaults().setCodableObject(user, forKey: K.userData)
            }
        }
    }
    
    private let firestoreManager = FirestoreDatabaseManager.shared
    var charts: [[String:Any]] = []
    
    func fetchCurrentUser(completion: @escaping (ERUser?, String?, Bool) -> ()){
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(nil, nil, false)
            return
        }
        
        GlobalVariables.shared.db.collection(ERUserModelName.firestore).document(userId).addSnapshotListener { response, error in
            if let userData = response?.data() {
                let user = ERUser.asObject(from: userData)
                self.currentUser = user
                NotificationCenter.default.post(name: .updateProfile, object: nil)
                completion(user, nil, true)
            }else{
                completion(nil, nil, false)
            }
        }
    }
}

extension UserDefaults {
    //To set custom object
    func setCodableObject<T: Codable>(_ data: T?, forKey defaultName: String) {
        let encoded = try? JSONEncoder().encode(data)
        set(encoded, forKey: defaultName)
    }
    
    //To retrieve custom object
    func codableObject<T : Codable>(dataType: T.Type, key: String) -> T? {
        guard let userDefaultData = data(forKey: key) else {
            return nil
        }
        return try? JSONDecoder().decode(T.self, from: userDefaultData)
    }
}

extension UserDefaults {
    static func resetDefaults() {
        if let bundleID = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundleID)
        }
    }
}
