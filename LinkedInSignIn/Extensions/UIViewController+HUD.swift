//
//  UIViewController+HUD.swift
//  GCCoreUI
//
//  Created by Serhii Londar on 11/9/17.
//  Copyright © 2017 Good&Co. All rights reserved.
//

import Foundation
import MBProgressHUD

extension UIViewController {
    open func showHUD() {
        DispatchQueue.main.async {
            let progressHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
            UIActivityIndicatorView.appearance(whenContainedInInstancesOf: [MBProgressHUD.self]).color = UIColor.white
            progressHUD.bezelView.color = UIColor(red:86.0/255.0, green: 192.0/255.0, blue: 241.0/255.0, alpha: 1.0)
            progressHUD.bringSubview(toFront: self.view)
        }
    }
    
    public func hideHUD() {
        DispatchQueue.main.async {
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
}
