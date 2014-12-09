//
//  Component.swift
//  CocoaPops
//
//  Created by Chris Hale on 08/12/2014.
//  Copyright (c) 2014 Strobe. All rights reserved.
//

import UIKit

class ClosureDispatch {
    let action: ()->Void
    init(f:()->Void) { self.action = f }
}

typealias ClosureReturnsComponents = (() -> [Component])
typealias PropDict = Dictionary<NSObject, AnyObject>
let ALLOWED_VIEW_PROPS: [NSObject] = ["frame", "view", "alpha", "hidden", "backgroundColor", "text"]

class Component {
    var children: [Component]
    var props: PropDict {
        didSet { self.draw() }
    }
    var type: String
    var _onClick: (()->Void)?
    
    @objc func onClick() {
        if _onClick != nil { self._onClick!() }
    }
    
    lazy var uiInstance: UIView? = {
        let typeClass = NSClassFromString(self.type) as? UIView.Type
        return typeClass?()
    }()
    
    init(type: String, props: PropDict, children childClosure: ClosureReturnsComponents?) {
        self.type = type
        self.props = props
        self.children = childClosure != nil ? childClosure!() : []
    }
    
    func draw() {
        var filteredProps = self.props.keys.filter { contains(ALLOWED_VIEW_PROPS, $0) }.map { (key: $0, value: self.props[$0]) }
        for prop in filteredProps {
            self.uiInstance?.setValue(prop.value!, forKey: prop.key as String)
        }
        
        if let clickClosure: ClosureDispatch = self.props["onClick"] as? ClosureDispatch {
            self._onClick = clickClosure.action
        }
        
        if let btn: UIButton = self.uiInstance as? UIButton {
            
            if let title: String = self.props["title"] as? String {
                btn.setTitle(title, forState: UIControlState.Normal)
            }
            
            btn.addTarget(self, action: "onClick", forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        for child in self.children as [Component] { child.draw() }
    }
    
    func render() -> UIView {
        for childComponent in children as [Component] {
            if childComponent.uiInstance != nil {
                self.uiInstance?.addSubview(childComponent.render())
            }
        }
        return self.uiInstance!
    }
    
}

func c(type: String, props: PropDict, children: ClosureReturnsComponents?) -> Component {
    return Component(type: type, props: props, children: children)
}
func c(type: String) -> Component {
    return c(type, [:], nil)
}
func c(type: String, props: PropDict) -> Component {
    return c(type, props, nil)
}
func c(type: String, children: ClosureReturnsComponents?) -> Component {
    return c(type, [:], children)
}
