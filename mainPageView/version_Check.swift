//
//  version_Check.swift
//  ClassFinder Pro
//
//  Created by ZhenQian on 5/25/19.
//  Copyright © 2019 ZhenQian. All rights reserved.
//

import Foundation

import Alamofire

class VersionCheck {
    
    public static let shared = VersionCheck()
    
    var newVersionAvailable: Bool?
    var appStoreVersion: String?
    
    func checkAppStore(callback: ((_ versionAvailable: Bool?, _ version: String?)->Void)? = nil) {
        let ourBundleId = Bundle.main.infoDictionary!["CFBundleIdentifier"] as! String
        Alamofire.request("https://itunes.apple.com/lookup?bundleId=\("ASU.SeatsFinderBot")").responseJSON { response in
            var isNew: Bool?
            var versionStr: String?
            
            if let json = response.result.value as? NSDictionary,
                let results = json["results"] as? NSArray,
                let entry = results.firstObject as? NSDictionary,
                let appVersion = entry["version"] as? String,
                let ourVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            {
                isNew = ourVersion != appVersion
                versionStr = appVersion
            }
            
            self.appStoreVersion = versionStr
            self.newVersionAvailable = isNew
            callback?(isNew, versionStr)
        }
    }
}
