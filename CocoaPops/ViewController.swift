//
//  ViewController.swift
//  CocoaPops
//
//  Created by Chris Hale on 05/12/2014.
//  Copyright (c) 2014 Strobe. All rights reserved.
//

import UIKit

class ViewController: ReactiveStateViewController {
    
    override func getInitialState() -> PropDict {
        return ["currentIndex": 0, "rows": ["one", "two"]]
    }
    
    override func getDefaultProps() -> PropDict {
        return ["frame": NSValue(CGRect: UIScreen.mainScreen().bounds), "backgroundColor": UIColor.blueColor()]
    }
    
    override func render() -> UIView {
        
        var currentIndex: Int = self.getState("currentIndex")
        var mainFrame: CGRect = UIScreen.mainScreen().bounds
        
        return UIView() {
            return [
                UIView(frame: mainFrame) {
                    let rows: [String] = self.getState("rows")
                    return rows.map({ (element: String, index: Int) -> UIView in
                        let y: CGFloat = (CGFloat(index)*100) as CGFloat
                        return UIButton(frame: CGRectMake(0, y, 100, 100), props: [
                            "title": element,
                            "backgroundColor": currentIndex == index ? "#111111" : "#ffffff",
                            "titleColor": currentIndex == index ? "#ffffff" : "#111111",
                            "onClick": ClosureDispatch(self.onButtonClick(index))
                        ])
                    })
                    
                }
            ]
        }
    }
    
    func onButtonClick(index: Int) -> (() -> Void) {
        return {
            self.setState([
                "currentIndex": index
            ])
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // DEBUG
    }
    
}
