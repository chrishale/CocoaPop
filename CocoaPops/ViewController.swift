//
//  ViewController.swift
//  CocoaPops
//
//  Created by Chris Hale on 05/12/2014.
//  Copyright (c) 2014 Strobe. All rights reserved.
//

import UIKit

class ViewController: CocoaPopUIViewController {
    
    lazy var exampleLabel: UILabel = {
        var label: UILabel = UILabel()
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        label.cp_listenForText("search.helpLabel") {
            if let searchOpen: Bool = CocoaPop.shared.getState("search.open") {
                return searchOpen ? "the search is open" : "the search is closed"
            }
            return ""
        }
        label.frame = CGRectMake(0, 0, self.view.frame.size.width, 150)
        return label
    }()
    
    lazy var searchOpenBtn: UIButton = {
        let button: UIButton = UIButton(frame: CGRectMake(0, 100, self.view.frame.size.width, 100))
        button.center = self.view.center
        button.addTarget(self, action: "toggleSearch", forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }()
    
    lazy var searchBar: UISearchBar = {
        let bar: UISearchBar = UISearchBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        return bar
    }()
    
    override func getInitialState() -> CocoaPopState {
        return CocoaPopState(dictionary: [
            "search.open": false,
            "search.helpLabel": "the search is open"
        ])
    }
    
    override func stateDidUpdate(prevState: CocoaPopState) {
        let searchOpen: Bool = CocoaPop.shared.getState("search.open")!
        self.searchBar.hidden = !searchOpen
        self.searchOpenBtn.setTitle(searchOpen ? "You are searching" : "Start search", forState: UIControlState.Normal)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.searchOpenBtn)
        self.view.addSubview(self.searchBar)
        self.view.addSubview(self.exampleLabel)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func toggleSearch() {
        if let searchOpen: Bool = CocoaPop.shared.getState("search.open") {
            CocoaPop.shared.setState([
                "search.open": !searchOpen
            ])
        }
    }

}

