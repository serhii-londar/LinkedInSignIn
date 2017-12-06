//
//  LinkedInLoginVC.swift
//  LISignIn
//
//  Created by Gabriel Theodoropoulos on 21/12/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

import UIKit
import MBProgressHUD

enum LinkedInLoginError: Error {
    case error(String)
}

class LinkedInLoginVC: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    
    var linkedInConfig: LinkedInConfig! = nil
    
    var loadingTitleString: String? = nil
    var loadingTitleFont: UIFont? = nil
    
    var completion: ((String) -> Void)? = nil
    var failure: ((Error) -> Void)? = nil
    var cancel: (() -> Void)? = nil
    
    let authorizationEndPoint = "https://www.linkedin.com/uas/oauth2/authorization"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        self.showHUD()
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        if let cancel = cancel {
            cancel()
        }
        dismiss(animated: true, completion: nil)
    }
    
    func login(linkedInConfig: LinkedInConfig, completion: @escaping (String) -> Void, failure: @escaping (Error) -> Void, cancel: @escaping (() -> Void)) {
        self.completion = completion
        self.failure = failure
        self.cancel = cancel
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
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.hideHUD()
    }
    
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
        if url.absoluteString.contains("error=access_denied") {
            failureString("Access Denied")
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
            return false
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

extension LinkedInLoginVC {
    func showHUD() {
        DispatchQueue.main.async {
            let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            UIActivityIndicatorView.appearance(whenContainedInInstancesOf: [MBProgressHUD.self]).color = UIColor.white
            if let labeltext = self.loadingTitleString {
                progressHUD?.labelText = labeltext
            }
            if let labelFont = self.loadingTitleFont {
                progressHUD?.labelFont = labelFont
            }
            progressHUD?.color = UIColor(red:86.0/255.0, green: 192.0/255.0, blue: 241.0/255.0, alpha: 1.0)
            progressHUD?.bringSubview(toFront: self.view)
        }
    }
    
    func hideHUD() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}
