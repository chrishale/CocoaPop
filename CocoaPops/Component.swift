//
//  Component.swift
//  CocoaPops
//
//  Created by Chris Hale on 08/12/2014.
//  Copyright (c) 2014 Strobe. All rights reserved.
//

//import UIKit
//
//class ClosureDispatch {
//    let action: ()->Void
//    init(f:()->Void) { self.action = f }
//}
//
//typealias ClosureReturnsComponents = (() -> [Component])
//typealias PropDict = Dictionary<NSObject, AnyObject>
//let ALLOWED_VIEW_PROPS: [NSObject] = ["frame", "view", "alpha", "hidden", "backgroundColor", "text"]
//
//class Component {
//
//    var type: String = "UIView"
//    var children: [Component] = []
//    var props: PropDict = [:]
//    var state: PropDict = [:] {
//        willSet { self.componentWillUpdate(newValue) }
//        didSet { self.componentDidUpdate(oldValue) }
//    }
//    
//    lazy var uiInstance: UIView = {
//        let typeClass = NSClassFromString(self.type) as? UIView.Type
//        return typeClass!()
//    }()
//    
//    init() {}
//    
//    init(props: PropDict) {
//        self.state = self.getInitialState()
//        self.props = props
//    }
//    
//    convenience init(type: String, props: PropDict) {
//        self.init(props: props)
//        self.type = type
//    }
//    
//    convenience init(props: PropDict, children childClosure: ClosureReturnsComponents) {
//        self.init(props: props)
//        self.children = childClosure()
//    }
//    convenience init(type: String, props: PropDict, children childClosure: ClosureReturnsComponents) {
//        self.init(props: props)
//        self.children = childClosure()
//    }
//    
//    func getInitialState() -> PropDict { return [:] }
//    
//    func componentWillUpdate(newState: PropDict) { }
//    
//    func componentDidUpdate(oldState: PropDict) { }
//    
//    func render() -> [Component] {
//        return []
//    }
//    
//    func draw() -> UIView {
//        var filteredProps = self.props.keys.filter { contains(ALLOWED_VIEW_PROPS, $0) }.map { (key: $0, value: self.props[$0]) }
//        for prop in filteredProps {
//            self.uiInstance.setValue(prop.value!, forKey: prop.key as String)
//        }
//        
////        if let clickClosure: ClosureDispatch = self.props["onClick"] as? ClosureDispatch {
////            self._onClick = clickClosure.action
////        }
//        
//        if let btn: UIButton = self.uiInstance as? UIButton {
//            
//            if let title: String = self.props["title"] as? String {
//                btn.setTitle(title, forState: UIControlState.Normal)
//            }
//            
//            btn.addTarget(self, action: "onClick", forControlEvents: UIControlEvents.TouchUpInside)
//        }
//        
//        for child in children as [Component] {
//            self.uiInstance.addSubview(child.render().draw())
//        }
//        return self.uiInstance
//    }
//    
//}
//
//func c(type: String, props: PropDict, children: ClosureReturnsComponents) -> Component {
//    return Component(type: type, props: props, children: children)
//}
//func c(type: String) -> Component {
//    return Component(type: type, props: [:])
//}
//func c(type: String, props: PropDict) -> Component {
//    return Component(type: type, props: props)
//}
//func c(type: String, children: ClosureReturnsComponents) -> Component {
//    return Component(type: type, props: [:], children: children)
//}
//if let clickClosure: ClosureDispatch = self.props["onClick"] as? ClosureDispatch {
//////            self._onClick = clickClosure.action
//////        }
//////var _onClick: (()->Void)?
//////
//////@objc func onClick() {
//////    if _onClick != nil { self._onClick!() }
//////}
//
