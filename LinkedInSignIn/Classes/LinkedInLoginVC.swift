//
//  LinkedInLoginVC.swift
//  LISignIn
//
//  Created by Gabriel Theodoropoulos on 21/12/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

import UIKit

enum LinkedInLoginError: Error {
    case error(String)
}

class LinkedInLoginVC: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    
    var linkedInConfig: LinkedInConfig! = nil
    
    var completion: ((String) -> Void)? = nil
    var failure: ((Error) -> Void)? = nil
    
    let authorizationEndPoint = "https://www.linkedin.com/uas/oauth2/authorization"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    func login(linkedInConfig: LinkedInConfig, completion: @escaping (String) -> Void, failure: @escaping (Error) -> Void) {
        self.completion = completion
        self.failure = failure
        self.linkedInConfig = linkedInConfig
        self.startAuthorization(linkedInConfig.scope)
    }
    
    func startAuthorization(_ scope: String) {
        let responseType = "code"
        let state = "linkedin\(Int(NSDate().timeIntervalSince1970))"
        
        var authorizationURL = "\(authorizationEndPoint)?"
        authorizationURL += "response_type=\(responseType)&"
        authorizationURL += "client_id=\(linkedInConfig.linkedInKey)&"
        authorizationURL += "redirect_uri=\(linkedInConfig.redirectURL)&"
        authorizationURL += "state=\(state)&"
        authorizationURL += "scope=\(scope)"
        
        print(authorizationURL)
        
        let url = URL(string: authorizationURL)
        let request = URLRequest(url: url!)
        webView.loadRequest(request)
    }
    
    
}

extension LinkedInLoginVC: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.url!
        if url.absoluteString.contains(authorizationEndPoint) {
            return true
        }
        if url.absoluteString.contains(linkedInConfig.redirectURL) && url.absoluteString.contains("code") {
            let urlParts = url.absoluteString.components(separatedBy: "?")
            let code = urlParts[1].components(separatedBy: "=")[1]
            completion(code)
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        return true
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.failureError(error)
    }
}


extension LinkedInLoginVC {
    func failureError(_ error: Error) {
        if let failure = failure {
            failure(LinkedInLoginError.error(error.localizedDescription))
        }
    }
    
    func failureString(_ error: String) {
        if let failure = failure {
            failure(LinkedInLoginError.error(error))
        }
    }
    
    func completion(_ accessToken: String) {
        if let completion = completion {
            completion(accessToken)
        }
    }
}
