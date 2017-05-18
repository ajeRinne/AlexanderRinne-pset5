//
//  toDoListItem.swift
//  Many Lists
//
//  Created by Alexander Rinne on 16-05-17.
//  Copyright © 2017 Alexander Rinne. All rights reserved.
//

import Foundation
import SQLite

import Foundation

struct ListItem{
    var id : Int64
    var name : String
    
    
    init (id : Int64, name : String){
        self.id = id
        self.name = name
    }
}
