//
//  LinkedInLoginVC.swift
//  LISignIn
//
//  Created by Gabriel Theodoropoulos on 21/12/15.
//  Copyright © 2015 Appcoda. All rights reserved.
//

import UIKit

class LinkedInLoginVC: UIViewController {
    @IBOutlet weak var webView: UIWebView!
    
    var linkedInConfig: LinkedInConfig! = nil
    
    var completion: ((String?) -> Void)? = nil
    var failure: (() -> Void)? = nil
    
    let authorizationEndPoint = "https://www.linkedin.com/uas/oauth2/authorization"
    let accessTokenEndPoint = "https://www.linkedin.com/uas/oauth2/accessToken"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.delegate = self
        startAuthorization()
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    static func login(linkedInConfig: LinkedInConfig, completion: @escaping (String?) -> Void, failure: @escaping () -> Void) {
        let linkedInLoginVC = LinkedInLoginVC()
        linkedInLoginVC.completion = completion
        linkedInLoginVC.failure = failure
        linkedInLoginVC.linkedInConfig = linkedInConfig
        linkedInLoginVC.startAuthorization()
    }
    
    func startAuthorization() {
        let responseType = "code"
        let state = "linkedin\(Int(NSDate().timeIntervalSince1970))"
        
        var authorizationURL = "\(authorizationEndPoint)?"
        authorizationURL += "response_type=\(responseType)&"
        authorizationURL += "client_id=\(linkedInConfig.linkedInKey)&"
        authorizationURL += "redirect_uri=\(linkedInConfig.redirectURL)&"
        authorizationURL += "state=\(state)&"
        authorizationURL += "scope=\(scope)"
        
        print(authorizationURL)
        
        let request = URLRequest(url: URL(string: authorizationURL)!)
        webView.loadRequest(request as URLRequest)
    }
    
    
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
            let statusCode = (response as! HTTPURLResponse).statusCode
            if statusCode == 200 {
                do {
                    let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                    
                    let accessToken = dataDictionary["access_token"] as! String
                    
                    UserDefaults.standard.set(accessToken, forKey: "LIAccessToken")
                    UserDefaults.standard.synchronize()
                    
                    DispatchQueue.main.async {
                        self.dismiss(animated: true, completion: nil)
                    }
                } catch {
                    print("Could not convert JSON data into a dictionary.")
                }
            }
        }
        task.resume()
    }
}

extension LinkedInLoginVC: UIWebViewDelegate {
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let url = request.url!
        print(url)
        
        if url.absoluteString.contains(linkedInConfig.redirectURL) && url.absoluteString.contains("code") {
            let urlParts = url.absoluteString.components(separatedBy: "?")
            let code = urlParts[1].components(separatedBy: "=")[1]
            requestForAccessToken(authorizationCode: code)
        }
        
        return true
    }
}
