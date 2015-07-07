//
//  PassingVariable.swift
//  MyChat
//
//  Created by Humberto Vieira de Castro on 7/7/15.
//  Copyright (c) 2015 Humberto Vieira de Castro. All rights reserved.
//

import Foundation
class Singleton {
    var name : String!
    
    class var sharedInstance: Singleton {
        
        struct Static {
            static var instance: Singleton?
            static var token: dispatch_once_t = 0
        }
        dispatch_once(&Static.token) {
            Static.instance = Singleton()
        }
        return Static.instance!
    }
}