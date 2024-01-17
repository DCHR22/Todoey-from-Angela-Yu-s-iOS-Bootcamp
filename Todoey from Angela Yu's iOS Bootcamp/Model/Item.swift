//
//  Item.swift
//  Todoey from Angela Yu's iOS Bootcamp
//
//  Created by Camilo L-Shide on 17/01/24.
//

import Foundation

class Item : Codable { // By conforming to the Codable Protocol, our Item instances can be encoded and decoded.
    var title : String = ""
    var done : Bool = false // This is set to be false per default since it will be cahnged to true only when the user taps the cell which means an the state of that cell item has changed from not done to done.
}
