//
//  ViewController.swift
//  CocoaPops
//
//  Created by Chris Hale on 05/12/2014.
//  Copyright (c) 2014 Strobe. All rights reserved.
//

import UIKit

class NavBarController: ReactiveStateViewController {
    
    override func render() -> UIView {
        return UIView(props: ["frame": NSValue(CGRect: CGRectInset(UIScreen.mainScreen().bounds, 100, 100)), "backgroundColor": UIColor.purpleColor()])
    }
    
}

class ViewController: ReactiveStateViewController {
    
    override func render() -> UIView {
        return UIView(props: ["frame": NSValue(CGRect: UIScreen.mainScreen().bounds), "backgroundColor": UIColor.blueColor()]) {
            [
                UIView(props: ["frame": NSValue(CGRect: CGRectInset(UIScreen.mainScreen().bounds, 50, 50)), "backgroundColor": UIColor.redColor()]),
                NavBarController().view
            ]
        }
    }
    
}
