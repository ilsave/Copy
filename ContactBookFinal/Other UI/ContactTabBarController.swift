//
//  ContactTabBarController.swift
//  ContactBookFinal
//
//  Created by Gushchin Ilya on 01.04.2021.
//

import UIKit

class ContactTabBarController: UITabBarController {
    
    struct SettingsBundleKeys {
        static let Reset = "RESET"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerSettingsBundle()
        NotificationCenter.default.addObserver(self, selector: #selector(ContactTabBarController.defaultsChanged), name: UserDefaults.didChangeNotification, object: nil)
        defaultsChanged()
        // Do any additional setup after loading the view.
    }
    
    func registerSettingsBundle(){
        let appDefaults = [String:AnyObject]()
        UserDefaults.standard.register(defaults: appDefaults)
    }
    
    @objc func defaultsChanged(){
        let contactsFirst = UserDefaults.standard.bool(forKey: SettingsBundleKeys.Reset)
        if contactsFirst == true {
            self.selectedIndex = 1
        } else {
            self.selectedIndex = 0
        }
    }
    
}
