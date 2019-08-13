//
//  PersonTableViewController.swift
//  Contacts
//
//  Created by Ruslan Kasian on 8/11/19.
//  Copyright © 2019 Ruslan Kasian. All rights reserved.
//

import UIKit
import CoreData

class PersonTableViewController: UITableViewController, UITextFieldDelegate {
    
    var initType: InitType = .create
    var person: Person?
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>?
    
    private var firstNameString = String()
    private var lastNameString = String()
    var profileImage = UIImage()
    
    private var phoneNumberArray = [String]()
    private var emailArray = [String]()
    private var addressArray = [String]()
    
    private var userDataArray: [Int : [String]] = [0: [],1: [],2: [], 3: []]//to store user data -> 0: main 1: phone, 2: email, 3: address
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView(frame: .zero)
        setupNavigationBar()
        switch initType{
        case .create:
            createNewPerson ()
        case .edite:
            editePerson ()
            tableView.reloadData()
        case .show:
            showPerson ()
            tableView.reloadData()
        }
    }
    
    func createNewPerson () {
        let phoneNumbers = ["#@#add#@#"]
        let emails = ["#@#add#@#"]
        let addresses = ["#@#add#@#"]
        profileImage = UIImage(named: "user")!
        phoneNumberArray = []
        emailArray = []
        addressArray = []
        
        
        userDataArray[1] = phoneNumbers
        userDataArray[2] = emails
        userDataArray[3] = addresses
    }
    
    func editePerson () {
        if let person = person {
            firstNameString = person.firstName ?? ""
            lastNameString = person.lastName ?? ""
            profileImage = UIImage(data: person.profileImage! as Data) ?? UIImage(named: "user")!
            var phoneNumbers = person.phoneNumbers as! [String]
            phoneNumberArray = phoneNumbers
            phoneNumbers.append("#@#add#@#")
            
            var emails = person.emails as! [String]
            emailArray = emails
            emails.append("#@#add#@#")
            
            var addresses = person.addresses as! [String]
            addressArray = addresses
            addresses.append("#@#add#@#")
            
            
            
            userDataArray[1] = phoneNumbers
            userDataArray[2] = emails
            userDataArray[3] = addresses
        }
    }
    
    func showPerson () {
        if let person = person {
            firstNameString = person.firstName ?? ""
            lastNameString = person.lastName ?? ""
            profileImage = UIImage(data: person.profileImage! as Data) ?? UIImage(named: "user")!
            let phoneNumbers = person.phoneNumbers as! [String]
            phoneNumberArray = phoneNumbers
            
            let emails = person.emails as! [String]
            emailArray = emails
            
            let addresses = person.addresses as! [String]
            addressArray = addresses
            
            
            //            if phoneNumbers.count > 0 {
            userDataArray[1] = phoneNumbers
            //            }else {
            //                userDataArray.removeValue(forKey: 1)
            //            }
            
            userDataArray[2] = emails
            userDataArray[3] = addresses
        }
    }
    
    // MARK: - View setup
    private func setupNavigationBar() {
        if #available(iOS 10.0, *) {
        self.navigationController?.navigationBar.prefersLargeTitles =  true
        }
        switch initType{
        case .create:
            let rightbuttonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveContactButtonAction))
            self.navigationItem.rightBarButtonItem = rightbuttonItem
            self.navigationItem.leftBarButtonItem = nil
        case .edite:
            let leftbuttonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonAction))
            let rightbuttonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveContactButtonAction))         
            self.navigationItem.rightBarButtonItem = rightbuttonItem
            self.navigationItem.leftBarButtonItem = leftbuttonItem
            
        case .show:
            let rightbuttonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editeContactButtonAction))
            self.navigationItem.rightBarButtonItem = rightbuttonItem
            self.navigationItem.leftBarButtonItem = nil
            
        }
    }

    @objc private func cancelButtonAction() {
        initType = .show
        viewDidLoad()
    }
    
    @objc private func editeContactButtonAction() {
        initType = .edite
        viewDidLoad()
    }
    
    @objc private func saveContactButtonAction() {
        
        saveUserInfo(firstName: firstNameString, lastName: lastNameString,
                     phoneNumbers: phoneNumberArray, emails: emailArray,
                     addresses: addressArray, profileImage: profileImage) { (result) in
                        if result {
                            switch initType{
                            case .create:
                                navigationController?.popViewController(animated: true)
                            case .edite:
                                initType = .show
                                viewDidLoad()
                            case .show:
                                break
                            }
                            
                        } else {
                            print("error saving")
                        }
        }
    }
    
    func saveUserInfo (firstName: String, lastName: String, phoneNumbers: [String], emails: [String], addresses: [String], profileImage: UIImage, completion: (_ complete: Bool) -> ()) {
        if let context = self.fetchedResultsController?.managedObjectContext {
            // Creating object
            if person == nil {
                person = Person(context: context)
            }
            
            // Saving object
            if let person = person {
                let profileImageData: Data = profileImage.pngData()!
                person.firstName = firstName
                person.lastName = lastName
                person.profileImage = profileImageData as NSData
                person.phoneNumbers = phoneNumbers as NSObject
                person.emails = emails as NSObject
                person.addresses = addresses as NSObject
                
                do {
                    CoreDataManager.sharedInstance.saveContext()
                    completion(true)
                    print("successfully saved person in core data")
                } catch {
                    print("Could not save. \(error.localizedDescription)")
                    completion(false)
                }
            }
        }
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return userDataArray.keys.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else  {
            return userDataArray[section]!.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "mainInfoCell", for: indexPath) as? MainInfoTableViewCell else {return UITableViewCell()}
            cell.firstNameOutlet.text = firstNameString
            cell.lastNameOutlet.text = lastNameString
            cell.firstNameOutlet.delegate = self
            cell.lastNameOutlet.delegate = self
            cell.photoOutlet.image = profileImage
            cell.initType = initType
            cell.vc = self
            return cell
        }
        else {
            let valueArray = userDataArray[indexPath.section]!
            let value = valueArray[indexPath.row]
            let dataType = ContactInfoType.contactdataType(numberSection: indexPath.section)
            
            if value == "#@#add#@#" {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "addInfoCell", for: indexPath) as? AddInfoPersonTableViewCell else {return UITableViewCell()}
                cell.addLAbleOutlet.text = "Add \(dataType.title)"
                return cell
            }
            else {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "secondInfoCell", for: indexPath) as? SecondInfoTableViewCell else {return UITableViewCell()}
                
                cell.infoLableOutlet.text = value
                return cell
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0 {
            return 150
        } else {
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if section == 0 {
            return nil
        } else {
            let sectionTitle = ContactInfoType.contactdataType(numberSection: section)
            return sectionTitle.title
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        switch initType{
        case .show : return false
        case .create, .edite:
            if indexPath.section == 0 {
                return false
            }
            else {
                let valueArray = userDataArray[indexPath.section]!
                let value = valueArray[indexPath.row]
                if value == "#@#add#@#" {
                    return false
                }
                else {
                    return true
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch initType {
        case .show:
            break
        case .create, .edite:
            if editingStyle == .delete {
                let section = indexPath.section
                let dataType = ContactInfoType.contactdataType(numberSection: section)
                var valueArray = userDataArray[section]!
                valueArray.remove(at: indexPath.row)
                valueArray.removeLast()
                switch dataType {
                case .phone:
                    self.phoneNumberArray = valueArray
                case .email:
                    self.emailArray = valueArray
                case .address:
                    self.addressArray = valueArray
                }
                valueArray.append("#@#add#@#")
                self.userDataArray[section] = valueArray
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let section = indexPath.section
        if section > 0 {
            
            var valueArray = userDataArray[section]!
            let value = valueArray[indexPath.row]
            let dataType = ContactInfoType.contactdataType(numberSection: section)
            
            
            if value == "#@#add#@#" {
                
                AlertService.addInfo(in: self, contactInfoType: dataType) {info in
                    
                    if !info.isEmpty {
                        valueArray.remove(at: indexPath.row)
                        valueArray.append(info)
                        switch dataType {
                        case .phone:
                            self.phoneNumberArray = valueArray
                        case .email:
                            self.emailArray = valueArray
                        case .address:
                            self.addressArray = valueArray
                        }
                        valueArray.append("#@#add#@#")
                        self.userDataArray[section] = valueArray
                        tableView.insertRows(at: [indexPath], with: .automatic)
                    }
                }
                
            }
        }
        
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let textFieldText: NSString = (textField.text ?? "") as NSString
        let txtAfterUpdate = textFieldText.replacingCharacters(in: range, with: string)
        if textField.tag == 1 {
            firstNameString = txtAfterUpdate
        }
        if textField.tag == 2 {
            lastNameString = txtAfterUpdate
        }
        
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
}


