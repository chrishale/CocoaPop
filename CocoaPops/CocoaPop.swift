//
//  CocoaPop.swift
//  CocoaPops
//
//  Created by Chris Hale on 05/12/2014.
//  Copyright (c) 2014 Strobe. All rights reserved.
//

import UIKit
import Dollar
import Cartography

typealias PropDict = Dictionary<String, AnyObject>
typealias StateDict = Dictionary<String, AnyObject>
typealias ClosureReturnsComponents = (() -> [UIView])
typealias FrameTuple = (x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat)
class ClosureDispatch {
    let action: ()->Void
    init(f:()->Void) { self.action = f }
}

enum DataType {
    case AsString(String)
    case AsInt(Int)
    case AsBool(Bool)
}

private var associationKey: UInt8 = 0

extension Array {
    func map<T>(transform: ((element: T, index: Int) -> UIView)) -> [UIView] {
        var result: [UIView] = []
        for (index, element) in enumerate(self) {
            let castedElement = element as T
            result.append(transform(element: castedElement, index: index))
        }
        return result
    }
}

extension UIView {
    
    var key: String! {
        get {
            return objc_getAssociatedObject(self, &associationKey) as? String
        }
        set(newValue) {
            objc_setAssociatedObject(self, &associationKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        }
    }
    
    private struct StoredProps {
        static var allowedProps: [String] = ["frame", "alpha", "hidden", "backgroundColor"]
    }
    
    class var allowedProps: [String] {
        get { return StoredProps.allowedProps }
        set { StoredProps.allowedProps = $.union(StoredProps.allowedProps, newValue) }
    }
    
    convenience init(props: PropDict) {
        self.init()
        self.setProps(props)
    }
    
    convenience init(props: PropDict, children: ClosureReturnsComponents) {
        self.init()
        for child in children() {
            self.addSubview(child)
        }
        self.setProps(props)
    }
    
    convenience init(children: ClosureReturnsComponents) {
        self.init()
        for child in children() {
            self.addSubview(child)
        }
    }
    
    convenience init(frame: CGRect, children: ClosureReturnsComponents) {
        self.init(frame: frame)
        for child in children() {
            self.addSubview(child)
        }
    }
    
    convenience init(frame: CGRect, props: PropDict, children: ClosureReturnsComponents) {
        self.init(frame: frame)
        for child in children() {
            self.addSubview(child)
        }
        self.setProps(props)
    }
    convenience init(frame: CGRect, props: PropDict) {
        self.init(frame: frame)
        self.setProps(props)
    }
    
    func setProps(newProps: PropDict) {
        
        var props: PropDict = newProps
        
        if let backgroundHex: String = props["backgroundColor"] as? String {
            self.backgroundColor = UIColor(rgba: backgroundHex)
            props.removeValueForKey("backgroundColor")
        }
        
        
        var filteredProps = props.keys.filter { contains(UIView.allowedProps, $0) }.map { (key: $0, value: props[$0]) }
        for prop in filteredProps {
            self.setValue(prop.value!, forKey: prop.key as String)
        }
        
        if let key: String = props["key"] as? String { self.key = key }
        

    }
}

private var clickKey: UInt8 = 1

extension UIButton {
    
    var _onClick: ClosureDispatch? {
        get {
            return objc_getAssociatedObject(self, &clickKey) as? ClosureDispatch
        }
        set(newValue) {
            objc_setAssociatedObject(self, &clickKey, newValue, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
        }
    }
    
    func onClick() {
        _onClick?.action()
    }
    
    override func setProps(props: PropDict) {
        super.setProps(props)
        
        if let clickClosure: ClosureDispatch = props["onClick"] as? ClosureDispatch {
            self._onClick = clickClosure
            self.addTarget(self, action: "onClick", forControlEvents: UIControlEvents.TouchUpInside)
        }
        
        if let title: String = props["title"] as? String {
            self.setTitle(title, forState: UIControlState.Normal)
        }
        
        
        if let titleColor: String = props["titleColor"] as? String {
            self.setTitleColor(UIColor(rgba: titleColor), forState: .Normal)
        }
        
        
    }
    
    
    
}

class ReactiveStateViewController: UIViewController {
    
    var props: PropDict = [:]
    var state: StateDict = [:] {
        willSet { self.componentWillUpdate(newValue) }
        didSet {
            self.componentDidUpdate(oldValue)
        }
    }

    func getInitialState() -> StateDict { return [:] }
    func getDefaultProps() -> PropDict { return [:] }

    func componentWillUpdate(newState: StateDict) { }
    func componentDidUpdate(oldState: StateDict) {
        self.view = self.render()
        self.view.setProps(self.props)
    }
    
    func setState(state: StateDict) {
        // TODO - move this into its own struct with operator overloading
        var newState: StateDict = self.state
        for (key, value) in state {
            newState[key] = value
        }
        self.state = newState
    }
    
    func getState<T: Any>(key:String) -> T {
        // lets just have it fail loudly
        return self.state[key]! as T
    }
    
    func getState<T: Any>(key: String, or: T) -> T {
        if let value: T = self.state[key] as? T {
            return value
        } else {
            return or
        }
    }
    
    func render() -> UIView { return UIView(frame: self.view.bounds) }
    
    override init() {
        super.init(nibName: nil, bundle: nil)
        self.props = self.getDefaultProps()
        self.state = self.getInitialState()
    }
    
    convenience init(props: PropDict) {
        self.init()
        var newProps: PropDict = self.props
        for (key, value) in props {
            newProps[key] = value
        }
        self.props = newProps
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = self.render()
        self.view.setProps(self.props)
    }
}