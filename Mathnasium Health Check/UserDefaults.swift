//
//  UserDefaults.swift
//  Mathnasium Health Check
//
//  Created by Kevin Aguilar on 6/25/21.
//

import Foundation
import Combine

class UserSettings: ObservableObject {
    @Published var username: String {
        didSet {
            UserDefaults.standard.set(username, forKey: "username")
        }
    }
    
    init() {
        self.username = UserDefaults.standard.object(forKey: "username") as? String ?? ""
    }
}
