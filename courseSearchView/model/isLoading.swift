//
//  isLoading.swift
//  ClassFinder Pro
//
//  Created by ZhenQian on 7/15/19.
//  Copyright © 2019 ZhenQian. All rights reserved.
//

import Foundation

class loadingController {
    private var isloading:Bool!
    init(isload:Bool) {
        self.isloading = isload
    }
    
    func getLoadingStatus() -> Bool {
        return self.isloading
    }
    func setLoadingStatus(isload:Bool){
        self.isloading = isload
    }
}
