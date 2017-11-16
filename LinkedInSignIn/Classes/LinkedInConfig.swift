//
//  LinkedInConfig.swift
//  LISignIn
//
//  Created by Serhii Londar on 11/16/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import Foundation

public class LinkedInConfig: NSObject {
    public var linkedInKey: String
    public var linkedInSecret: String
    public var redirectURL: String
    public var scope: String
    
    public init(linkedInKey: String, linkedInSecret: String, redirectURL: String, scope: String = "r_basicprofile") {
        self.linkedInKey = linkedInKey
        self.linkedInSecret = linkedInSecret
        self.redirectURL = redirectURL
        self.scope = scope
    }
}
