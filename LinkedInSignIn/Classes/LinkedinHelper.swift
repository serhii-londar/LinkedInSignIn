//
//  LinkedinHelper.swift
//  LISignIn
//
//  Created by Serhii Londar on 11/16/17.
//  Copyright © 2017 Appcoda. All rights reserved.
//

import Foundation
import UIKit
import WebKit

enum LinkedinHelperError: Error {
    case error(String)
}

@objc public class LinkedinHelper: NSObject {
    var linkedInConfig: LinkedInConfig! = nil
    var linkedInLoginVC: LinkedInLoginVC! = nil
    var completion: ((String) -> Void)? = nil
    var failure: ((Error) -> Void)? = nil
    var cancel: (() -> Void)? = nil
    
    let accessTokenEndPoint = "https://www.linkedin.com/uas/oauth2/accessToken"
    
    @objc public init(linkedInConfig: LinkedInConfig) {
        self.linkedInConfig = linkedInConfig
    }
    
    @objc public func login(from viewController: UIViewController, loadingTitleString: String? = nil,  loadingTitleFont: UIFont? = nil, navigationColor: UIColor = UIColor(red: 0, green: 119.0 / 255.0, blue: 181.0 / 255.0, alpha: 1.0), completion: @escaping (String) -> Void, failure: @escaping (Error) -> Void, cancel: @escaping () -> Void) {
        self.completion = completion
        self.failure = failure
        self.cancel = cancel
        
        let storyboard = UIStoryboard(name: "LinkedInLoginVC", bundle: Bundle(for: LinkedInLoginVC.self))
        linkedInLoginVC = storyboard.instantiateViewController(withIdentifier: "LinkedInLoginVC") as? LinkedInLoginVC
        linkedInLoginVC.loadingTitleString = loadingTitleString
        linkedInLoginVC.loadingTitleFont = loadingTitleFont
        linkedInLoginVC.navigationColor = navigationColor
        linkedInLoginVC.loadViewIfNeeded()
        linkedInLoginVC.login(linkedInConfig: linkedInConfig, completion: { (code) in
            self.requestForAccessToken(authorizationCode: code)
        }, failure: { (error) in
            self.failureError(error)
        }) {
            DispatchQueue.main.async {
                self.linkedInLoginVC.dismiss(animated: true, completion: {
                    if let cancel = self.cancel {
                        cancel()
                    }
                })
            }
        }
        viewController.present(linkedInLoginVC, animated: true, completion: nil)
    }
    
    public func logOut(_ completion: (() -> Void)? = nil) {
        let dataTypes = Set([WKWebsiteDataTypeCookies])
        WKWebsiteDataStore.default().removeData(ofTypes: dataTypes, modifiedSince: NSDate.distantPast, completionHandler: completion ?? {})
    }
    
    @objc func logOut() {
        self.logOut(nil)
    }
}


extension LinkedinHelper {
    func failureError(_ error: Error) {
        DispatchQueue.main.async {
            self.linkedInLoginVC.dismiss(animated: true, completion: {
                if let failure = self.failure {
                    failure(LinkedInLoginError.error(error.localizedDescription))
                }
            })
        }
    }
    
    func failureString(_ error: String) {
        DispatchQueue.main.async {
            self.linkedInLoginVC.dismiss(animated: true, completion: {
                if let failure = self.failure {
                    failure(LinkedInLoginError.error(error))
                }
            })
        }
    }
    
    func completion(_ accessToken: String) {
        DispatchQueue.main.async {
            self.linkedInLoginVC.dismiss(animated: true, completion: {
                if let completion = self.completion {
                    completion(accessToken)
                }
            })
        }
    }
}


extension LinkedinHelper {
    func requestForAccessToken(authorizationCode: String) {
        let grantType = "authorization_code"
        var postParams = "grant_type=\(grantType)&"
        postParams += "code=\(authorizationCode)&"
        postParams += "redirect_uri=\(linkedInConfig.redirectURL)&"
        postParams += "client_id=\(linkedInConfig.linkedInKey)&"
        postParams += "client_secret=\(linkedInConfig.linkedInSecret)"
        
        let postData = postParams.data(using: String.Encoding.utf8)
        var request = URLRequest(url: URL(string: accessTokenEndPoint)!)
        request.httpMethod = "POST"
        request.httpBody = postData
        request.addValue("application/x-www-form-urlencoded;", forHTTPHeaderField: "Content-Type")
        let session = URLSession(configuration: URLSessionConfiguration.default)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) -> Void in
            if let response = response {
                let statusCode = (response as! HTTPURLResponse).statusCode
                if statusCode == 200 {
                    do {
                        let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                        if let accessToken = dataDictionary["access_token"] as? String {
                            self.completion(accessToken)
                        } else {
                            self.failureString("Could not get access_token from json.")
                        }
                    } catch {
                        self.failureString("Could not convert JSON data into a dictionary.")
                    }
                } else {
                    self.failureString("Received error with code: \(statusCode)")
                }
            } else {
                if let error = error {
                    self.failureError(error)
                } else {
                    self.failureString("Response and error is ni.l")
                }
            }
        }
        task.resume()
    }
}
