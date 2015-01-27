// Playground - noun: a place where people can play

import UIKit

var xPath: [Int] = [0,1,1]

var test: String = xPath.reduce("") { "\($0).\($1)" }

println(test)
