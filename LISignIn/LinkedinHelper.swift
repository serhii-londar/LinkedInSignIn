//
//  LinkedinHelper.swift
//  LISignIn
//
//  Created by Serhii Londar on 11/16/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import Foundation
import UIKit

public class LinkedinHelper: NSObject {
    var linkedInConfig: LinkedInConfig! = nil
    
    init(linkedInConfig: LinkedInConfig) {
        self.linkedInConfig = linkedInConfig
    }
    
    public func login(from viewController: UIViewController, completion: @escaping (String?) -> Void, failure: @escaping () -> Void) {
        
    }
}
