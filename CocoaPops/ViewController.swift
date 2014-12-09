//
//  ViewController.swift
//  CocoaPops
//
//  Created by Chris Hale on 05/12/2014.
//  Copyright (c) 2014 Strobe. All rights reserved.
//

import UIKit

class ViewController: CocoaPopUIViewController {
    
    override func getInitialState() -> PropDict {
        return [
            "search.open": false
        ]
    }
    
    override func render() -> Component {
        let searchOpen: Bool? = self.state["searchOpen"] as? Bool
        
        return c("UIView", [
            "backgroundColor": UIColor.greenColor(),
            "frame": NSValue(CGRect: UIScreen.mainScreen().bounds)
        ]) {[
            c("UILabel", [
                "text": "this is the title",
                "hidden": searchOpen != nil ? searchOpen! : false,
                "alpha": 0.5,
                "frame": NSValue(CGRect: CGRectMake(0, 100, 300, 100))
            ]),
            c("UIButton", [
                "frame": NSValue(CGRect: CGRectMake(0, 0, 300, 100)),
                "title": "Click me",
                "onClick": ClosureDispatch({ self.toggleSearch() })
            ])
        ]}
    }
    
    func toggleSearch() {
        let searchOpen: Bool = self.state["searchOpen"] != nil ? (self.state["searchOpen"]! as Bool) : false
        self.setState(["searchOpen":  !searchOpen])
    }

}

