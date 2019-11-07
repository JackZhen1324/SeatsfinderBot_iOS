//
//  getTerms .swift
//  ClassFinder Pro
//
//  Created by ZhenQian on 7/15/19.
//  Copyright © 2019 ZhenQian. All rights reserved.
//

import Foundation

class getTerms {
    
    static func getTerms()->[String]{
        var termList = [""]
        termList.removeAll()
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "MM"
        let formattedDate = format.string(from: date)
        
        if(Int(formattedDate)!<=6)
        {format.dateFormat = "YYYY"
            
            print(termList)
            let currentYear = format.string(from: date)
            termList.append("Fall \(Int(currentYear)!-1)")
            print(termList)
            termList.append("Spring \(currentYear)")
            termList.append("Fall \(currentYear)")
            //searchController.searchBar.scopeButtonTitles?.append("Spring \(currentYear)")
            //searchController.searchBar.scopeButtonTitles?.append("Fall \(currentYear)")
            
        }
        else{
            format.dateFormat = "YYYY"
            let currentYear = format.string(from: date)
            //searchController.searchBar.scopeButtonTitles?.append("Fall \(currentYear)")
            //searchController.searchBar.scopeButtonTitles?.append("Spring \(Int(currentYear)!+1)")
            print(currentYear)
            termList.append("Spring \(currentYear)")
            print(termList)
            termList.append("Fall \(currentYear)")
            termList.append("Spring \(Int(currentYear)!+1)")
            
        }
        return termList
        
        
    }
    

    
    
    

}
