//
//  ViewController.swift
//  LinkedInSignIn
//
//  Created by Serhii Londar on 11/16/2017.
//  Copyright (c) 2017 Serhii Londar. All rights reserved.
//

import UIKit
import LinkedInSignIn

let linkedinCredentilas = [
    "linkedInKey": "",
    "linkedInSecret": "",
    "redirectURL": ""
]


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
        let linkedInConfig = LinkedInConfig(linkedInKey: linkedinCredentilas["linkedInKey"]!, linkedInSecret: linkedinCredentilas["linkedInSecret"]!, redirectURL: linkedinCredentilas["redirectURL"]!)
        let linkedInHelper = LinkedinHelper(linkedInConfig: linkedInConfig)
        linkedInHelper.login(from: self, loadingTitleString: "Loading", completion: { (token) in
            let alertVC = UIAlertController(title: "Success", message: "Your access token is : \(token)!", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                alertVC.dismiss(animated: true, completion: nil)
            }))
            self.present(alertVC, animated: true, completion: nil)
        }, failure: { (error) in
            print(error.localizedDescription)
        }) {
            print("Cancel")
        }
    }
}

