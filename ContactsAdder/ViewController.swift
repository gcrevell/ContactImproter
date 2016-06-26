//
//  ViewController.swift
//  ContactsAdder
//
//  Created by Gabriel Revells on 6/25/16.
//  Copyright © 2016 Gabriel Revells. All rights reserved.
//

import UIKit
import Contacts

let FAMILY_NAME = "iD Tech"
let DEPARTMENT = "STUDENT ADDED WITH CONTANCT APP"

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let contacts = CNContactStore()
        
        let status = CNContactStore.authorizationStatus(for: CNEntityType.contacts)
        
        switch status {
        case .authorized:
            // UM
            print("Authorized")
            
        case .restricted, .denied:
            print("NOPE")
            
        case .notDetermined:
            print("WHO KNOWS")
        }
        
        contacts.requestAccess(for: .contacts) { (allowed, nil) in
            
        }
        
        let count = (UIApplication.shared().delegate as! AppDelegate).count
        
        if count > 0 {
            let alert = UIAlertController(title: "Whoops", message: "Failed to add \(count) contacts. Try again?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func deleteContacts(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Delete", message: "This will delete all contacts added by this app in your address book with the last name \(FAMILY_NAME).", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            let pred = CNContact.predicateForContacts(matchingName: FAMILY_NAME)
            
            let store = CNContactStore()
            
            let contacts = try! store.unifiedContacts(matching: pred, keysToFetch: [CNContactPhoneNumbersKey, CNContactGivenNameKey, CNContactFamilyNameKey, CNContactDepartmentNameKey])
            
            let req = CNSaveRequest()
            
            for contact in contacts {
                if contact.familyName == FAMILY_NAME && contact.departmentName == DEPARTMENT {
                    
                    req.delete(contact.mutableCopy() as! CNMutableContact)
                }
            }
            
            try! store.execute(req)
            print("Done")
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }

}

