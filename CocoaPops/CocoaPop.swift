//
//  CocoaPop.swift
//  CocoaPops
//
//  Created by Chris Hale on 05/12/2014.
//  Copyright (c) 2014 Strobe. All rights reserved.
//

import UIKit

@objc class CocoaPopState: SequenceType {
    var map = [String:AnyObject?]()
    
    init() {}
    
    init(dictionary: Dictionary<String, AnyObject?>) {
        for (k,v) in dictionary {
            map[k] = v
        }
    }
    
    subscript(key: String) -> AnyObject? {
        get {
            return map[key]?
        }
        set(newValue) {
            map[key] = newValue
        }
    }
    
    func generate() -> GeneratorOf<(String, AnyObject?)> {
        var gen = map.generate()
        return GeneratorOf() {
            return gen.next()
        }
    }
    
}

@objc protocol CocoaPopStateDelegate {
    func getInitialState() -> CocoaPopState
    func stateDidUpdate(prevState: CocoaPopState)
    func stateDidUpdateWithNotification(notification: NSNotification)
}

class CocoaPopUIViewController: UIViewController, CocoaPopStateDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        CocoaPop.shared.observe(self)
    }
    
    func getInitialState() -> CocoaPopState { return CocoaPopState() }
    
    func stateDidUpdate(prevState: CocoaPopState) { }

    func stateDidUpdateWithNotification(notification: NSNotification) {
        if let state = notification.object as? CocoaPopState {
            self.stateDidUpdate(state)
        }
    }
    
    deinit {
        CocoaPop.shared.removeObserver(self)
    }
    
}

class CocoaPop {
    
    var prevState: CocoaPopState?

    private var state: CocoaPopState = CocoaPopState() {
        didSet {
            NSNotificationCenter.defaultCenter().postNotificationName("CocoaPop.stateDidUpdate", object: prevState)
        }
    }
    
    struct Singleton {
        static let shared = CocoaPop()
    }
    
    class var shared: CocoaPop {
        return Singleton.shared
    }

    func touch() {
        NSNotificationCenter.defaultCenter().postNotificationName("CocoaPop.stateDidUpdate", object: CocoaPopState(dictionary: CocoaPop.shared.state.map))
    }
    
    func setState(state newState: CocoaPopState) {
        var existingState: CocoaPopState = CocoaPopState(dictionary: self.state.map)
        prevState = existingState
        for (k, v) in newState {
            existingState[k] = v
        }
        self.state = existingState
    }
    
    func setState(state: Dictionary<String, AnyObject?>) {
        self.setState(state: CocoaPopState(dictionary: state))
    }
    
    func getState<T>(key: String) -> T? {
        if let value: T = self.state[key] as? T {
            return value
        }
        return nil
    }
    
    func observe(target: AnyObject) {
        if let delegate: CocoaPopStateDelegate = target as? CocoaPopStateDelegate {
            NSNotificationCenter.defaultCenter().addObserver(target, selector: "stateDidUpdateWithNotification:", name: "CocoaPop.stateDidUpdate", object: nil)
            self.setState(state: delegate.getInitialState())
        }
    }
    
    func removeObserver(target: AnyObject) {
        NSNotificationCenter.defaultCenter().removeObserver(target)
    }
    
}

extension UILabel {
    func cp_listenForText(key: String, withString: () -> String) {
        NSNotificationCenter.defaultCenter().addObserverForName("CocoaPop.stateDidUpdate", object: nil, queue: nil, usingBlock: {
            (notification: NSNotification!) in
            self.text = withString()
        })
        self.text = withString()
    }
}

extension UIView {

}
