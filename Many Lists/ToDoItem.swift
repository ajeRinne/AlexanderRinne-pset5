//
//  ToDoItem.swift
//  Many Lists
//
//  Created by Alexander Rinne on 15-05-17.
//  Copyright © 2017 Alexander Rinne. All rights reserved.
//

import Foundation
import SQLite

import Foundation

struct ToDoItem{
    var text : String
    var list : Int64
    var id : Int64
    var checked : Int64
    
    
    init (text : String, list : Int64, id : Int64, checked : Int64){
        self.text = text
        self.list = list
        self.id = id
        self.checked = checked
    }
}
