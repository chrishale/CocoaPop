//
//  CocoaPop.swift
//  CocoaPops
//
//  Created by Chris Hale on 05/12/2014.
//  Copyright (c) 2014 Strobe. All rights reserved.
//

import UIKit

typealias PropDict = Dictionary<NSObject, AnyObject>
typealias ClosureReturnsComponents = (() -> [UIView])
let ALLOWED_VIEW_PROPS: [NSObject] = ["frame", "view", "alpha", "hidden", "backgroundColor", "text"]

extension UIView {
    convenience init(props: PropDict) {
        self.init()
        self.setProps(props)
    }
    
    convenience init(props: PropDict, children: ClosureReturnsComponents) {
        self.init(props: props)
        for child in children() {
            self.addSubview(child)
        }
    }
    
    convenience init(children: ClosureReturnsComponents) {
        self.init()
        for child in children() {
            self.addSubview(child)
        }
    }
    
    func setProps(props: PropDict) {
        var filteredProps = props.keys.filter { contains(ALLOWED_VIEW_PROPS, $0) }.map { (key: $0, value: props[$0]) }
        for prop in filteredProps {
            self.setValue(prop.value!, forKey: prop.key as String)
        }
    }
}

class ReactiveStateViewController: UIViewController {

    var props: PropDict = [:]
    var state: PropDict = [:] {
        willSet { self.componentWillUpdate(newValue) }
        didSet {
            self.componentDidUpdate(oldValue)
        }
    }

    func getInitialState() -> PropDict { return [:] }
    func getDefaultProps() -> PropDict { return [:] }

    func componentWillUpdate(newState: PropDict) { }
    func componentDidUpdate(oldState: PropDict) { }
    
    func setState(newState: PropDict) {
        var oldState: PropDict = self.state
        for (key, value) in newState {
            oldState[key] = value
        }
        self.state = oldState
    }
    
    func render() -> UIView { return UIView(frame: self.view.bounds) }
    
    override func loadView() {
        super.loadView()
        self.props = self.getDefaultProps()
        self.state = self.getInitialState()
        
        self.view.setProps(self.props)
        
        self.view.addSubview(self.render())
    }
    
    func diffAgainstRender() {
        
    }
}


//// check if subview is available
//if let availableViews: [UIView] = rootNode.subviews.filter({ (subview: AnyObject) in
//    return subview.isKindOfClass(NSClassFromString(component.type))
//}) as? [UIView] {
//    
//    var exactView: UIView? = availableViews.filter({ $0.tag == index }).first
//    
//    var componentView: UIView
//    
//    if exactView == nil {
//        let typeClass = NSClassFromString(component.type) as? UIView.Type
//        componentView = typeClass!()
//        rootNode.addSubview(componentView)
//    } else {
//        componentView = exactView!
//    }
//    
//    componentView.tag = index
//    
//    var filteredProps = component.props.keys.filter { contains(ALLOWED_VIEW_PROPS, $0) }.map { (key: $0, value: component.props[$0]) }
//    for prop in filteredProps {
//        componentView.setValue(prop.value!, forKey: prop.key as String)
//    }
//    
//    // recursivley render
//    component.fetchObjectModel(componentView).render()
//    
//}
