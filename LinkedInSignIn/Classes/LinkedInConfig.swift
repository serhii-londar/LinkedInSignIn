//
//  LinkedInConfig.swift
//  LISignIn
//
//  Created by Serhii Londar on 11/16/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import Foundation

@objc public class LinkedInConfig: NSObject {
    @objc public var linkedInKey: String
    @objc public var linkedInSecret: String
    @objc public var redirectURL: String
    @objc public var scope: String
    
    @objc public init(linkedInKey: String, linkedInSecret: String, redirectURL: String, scope: String = "r_basicprofile") {
        self.linkedInKey = linkedInKey
        self.linkedInSecret = linkedInSecret
        self.redirectURL = redirectURL
        self.scope = scope
    }
}
