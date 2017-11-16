//
//  ViewController.swift
//  LinkedInSignIn
//
//  Created by Serhii Londar on 11/16/2017.
//  Copyright (c) 2017 Serhii Londar. All rights reserved.
//

import UIKit
import LinkedInSignIn

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func login(_ sender: AnyObject) {
        let linkedInConfig = LinkedInConfig(linkedInKey: "490br8vpy5nf", linkedInSecret: "NpURUk3inPSz3ekp", redirectURL: "https://www.facebook.com/connect/login_success.html")
        let linkedInHelper = LinkedinHelper(linkedInConfig: linkedInConfig)
        linkedInHelper.login(from: self, completion: { (accessToken) in
            let alertVC = UIAlertController(title: "Success", message: "Your access token is : \(accessToken)!", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                alertVC.dismiss(animated: true, completion: nil)
            }))
            self.present(alertVC, animated: true, completion: nil)
        }) { error in
            print(error.localizedDescription)
        }
    }
}

