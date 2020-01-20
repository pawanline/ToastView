//
//  ViewController.swift
//  ToastView
//
//  Created by Pawan Kumar on 13/01/20.
//  Copyright © 2020 Pawan Kumar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        AppToast.default.showToastMessage(message: "Hello", onViewController: self, duration: 1, buttonTitle: "", buttonImage: UIImage(named: "close"), spaceFromTop: 0, buttonAction: {
            AppToast.default.hideToast()
        }, toastDidClose: {
            print("close button tapped")
        })
        
    }
}

