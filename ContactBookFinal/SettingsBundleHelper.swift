//
//  SettingsBundleHelper.swift
//  ContactBookFinal
//
//  Created by Gushchin Ilya on 01.04.2021.
//

import Foundation

class SettingsBundleHelper {
    struct SettingsBundleKeys {
        static let Reset = "RESET"
    }
    func checkAndExecuteSettings() {
        print("ya tut bul...")
        if UserDefaults.standard.bool(forKey: SettingsBundleKeys.Reset) {
            //logic with is 
            
            
            
            
            
//            UserDefaults.standard.set(false, forKey: SettingsBundleKeys.Reset)
//            let appDomain: String? = Bundle.main.bundleIdentifier
//            UserDefaults.standard.removePersistentDomain(forName: appDomain!)
            print("ya tut bul...")
            // reset userDefaults..
            // CoreDataDataModel().deleteAllData()
            // delete all other user data here..
        }
    }
    
    class func setVersionAndBuildNumber() {
        let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        UserDefaults.standard.set(version, forKey: "version_preference")
        let build: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as! String
        UserDefaults.standard.set(build, forKey: "build_preference")
    }
}
