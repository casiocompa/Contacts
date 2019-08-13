//
//  AlertService.swift
//  Contacts
//
//  Created by Ruslan Kasian on 8/12/19.
//  Copyright © 2019 Ruslan Kasian. All rights reserved.
//

import UIKit

class AlertService {
    
    private init() {}
    
    static func addInfo(in vc: UIViewController, contactInfoType: ContactInfoType, completion: @escaping (String) -> Void) {
        let alert = UIAlertController(title: contactInfoType.title, message: nil, preferredStyle: .alert)
        alert.addTextField { (infoTextField) in
            infoTextField.placeholder = contactInfoType.title
            infoTextField.keyboardType = contactInfoType.keyboardType
        }
    
        let add = UIAlertAction(title: "Add", style: .default) { _ in
            guard let info = alert.textFields?.first?.text else { return }
            completion(info)
        }
        alert.addAction(add)
        vc.present(alert, animated: true)
    }
    
    static func updateInfo(_ info: String, in vc: UIViewController, contactInfoType: ContactInfoType, completion: @escaping (String) -> Void) {
        let alert = UIAlertController(title: contactInfoType.title, message: nil, preferredStyle: .alert)
        alert.addTextField { (infoTextField) in
            infoTextField.placeholder = contactInfoType.title
            infoTextField.keyboardType = contactInfoType.keyboardType
            infoTextField.text = info
        }
        
        let update = UIAlertAction(title: "Update", style: .default) { _ in
            guard let infoUpdate = alert.textFields?.first?.text else { return }
            completion(infoUpdate)
        }
        alert.addAction(update)
        vc.present(alert, animated: true)
    }
    
    
//    static func update(_ user: User, in vc: UIViewController, completion: @escaping (User) -> Void) {
//        let alert = UIAlertController(title: "Update \(user.name)", message: nil, preferredStyle: .alert)
//        alert.addTextField { (ageTF) in
//            ageTF.placeholder = "Age"
//            ageTF.keyboardType = .numberPad
//            ageTF.text = String(user.age)
//        }
//        let update = UIAlertAction(title: "Update", style: .default) { _ in
//            guard
//                let ageString = alert.textFields?.last?.text,
//                let age = Int(ageString)
//                else { return }
//
//            var updatedUser = user
//            updatedUser.age = age
//
//            completion(updatedUser)
//        }
//        alert.addAction(update)
//        vc.present(alert, animated: true)
//    }

}
