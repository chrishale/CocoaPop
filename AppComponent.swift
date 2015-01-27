////
////  App.swift
////  CocoaPops
////
////  Created by Chris Hale on 09/12/2014.
////  Copyright (c) 2014 Strobe. All rights reserved.
////
//
//import UIKit
//
//class AppComponent: Component {
//
////    override func render() -> Component {
////        return c("UIView", [
////            "backgroundColor": UIColor.redColor(),
////            "frame": NSValue(CGRect: self.uiInstance.frame)
////        ]) { [c("UIView") { [] }] }
////    }
//
//    override func render() -> Component {
//        return c("UIView", ["backgroundColor": UIColor.redColor()]) {
//            [NavComponent(props: ["frame": NSValue(CGRect: self.uiInstance.frame)])]
//        }
//    }
//    
//    
//}
//
////override func render() -> Component {
////    let searchOpen: Bool? = self.state["searchOpen"] as? Bool
////    
////    return c("UIView", [
////        "backgroundColor": UIColor.greenColor(),
////        "frame": NSValue(CGRect: UIScreen.mainScreen().bounds)
////        ]) {[
////            c("UILabel", [
////                "text": "this is the title",
////                "hidden": searchOpen != nil ? searchOpen! : false,
////                "alpha": 0.5,
////                "frame": NSValue(CGRect: CGRectMake(0, 100, 300, 100))
////                ]),
////            c("UIButton", [
////                "frame": NSValue(CGRect: CGRectMake(0, 0, 300, 100)),
////                "title": "Click me",
////                "onClick": ClosureDispatch({ self.toggleSearch() })
////                ])
////            ]}
////}