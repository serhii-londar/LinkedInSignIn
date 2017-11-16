//
//  LinkedInConfig.swift
//  LISignIn
//
//  Created by Serhii Londar on 11/16/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import Foundation

public class LinkedInConfig: NSObject {
    public var linkedInKey: String! = nil// = "490br8vpy5nf"
    public var linkedInSecret: String! = nil// = "NpURUk3inPSz3ekp"
    public var redirectURL: String! = nil// = "https://www.facebook.com/connect/login_success.html"
    public var scope: String! = nil
    
    public init(linkedInKey: String, linkedInSecret: String, redirectURL: String, scope: String = "r_basicprofile") {
        self.linkedInKey = linkedInKey
        self.linkedInSecret = linkedInSecret
        self.redirectURL = redirectURL
    }
}
