//
//  CocoaPop.swift
//  CocoaPops
//
//  Created by Chris Hale on 05/12/2014.
//  Copyright (c) 2014 Strobe. All rights reserved.
//

import UIKit

@objc protocol CocoaPopStateDelegate {
    func getInitialState() -> PropDict
    func componentDidUpdate(prevState: PropDict)
    func componentWillUpdate(nextState: PropDict)
}

class CocoaPopUIViewController: UIViewController, CocoaPopStateDelegate {
    
    var root: Component?
    
    var state: PropDict = [:] {
        willSet {
            self.componentWillUpdate(newValue)
        }
        didSet {
            self.componentDidUpdate(oldValue)
        }
    }
    
    func setState(state: PropDict) {
        var newState: PropDict = self.state
        for (k,v) in state {
            newState.updateValue(v, forKey: k)
        }
        self.state = newState
    }
    
    func getInitialState() -> PropDict { return [:] }
    func componentDidUpdate(prevState: PropDict) {
        println(render().render())
    }
    func componentWillUpdate(nextState: PropDict) { }
    
    override func loadView() {
        super.loadView()
        self.state = self.getInitialState()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = render().render()
    }
        
    func render() -> Component { return c("UIView") }
    
}
