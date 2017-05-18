//
//  ToDoManager.swift
//  Many Lists
//
//  Created by Alexander Rinne on 12-05-17.
//  Copyright © 2017 Alexander Rinne. All rights reserved.
//

import Foundation
import SQLite

class ToDoManager {
    
    private init() {
        setupToDoDatabase()
    }
    

    
    private var db: Connection?
    
    let listTable = Table("lists")
    let listID = Expression<Int64>("listID")
    let listName = Expression<String>("listName")

    
    let toDoTable = Table("toDos")
    let toDoID = Expression<Int64>("toDoID")
    var toDoListID = Expression<Int64>("listID")
    let toDo = Expression<String?>("toDo")
    var toDoChecked = Expression<Int64?>("checked")

//    Make a connection with the database for to dos table
    private func setupToDoDatabase(){
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        print(path)
        do {
            db = try Connection("\(path)/db.sqlite3")
            createToDoTable()
            createListTable()
        } catch {
            print("Cannot connect to database: \(error)")
        }
    }

//    Create list of to do lists
    private func createListTable() {
        
        do { try db!.run(listTable.create(ifNotExists: true) { t in
            t.column(listID, primaryKey: .autoincrement)
            t.column(listName)
            })
        } catch {
            print("Failed to create list table \(error)")
        }
    }
    
    
//    Create list of to dos
    private func createToDoTable() {

        do {
            try db!.run(toDoTable.create(ifNotExists: true) { t in
                t.column(toDoID, primaryKey: .autoincrement)
                t.column(toDoListID)
                t.column(toDo)
                t.column(toDoChecked)
            })
        } catch {
            print("Failed to create table: \(error)")
        }
    }
    
//    Insert function for to do list in to do manager
    func insertToDo(toDoText : String, listID : Int64){
        let insert = self.toDoTable.insert(self.toDo <- toDoText, self.listID <- listID)
        do{
            let rowID = try self.db!.run(insert)
            print(rowID)
        } catch {
            print("Cannot insert into database: \(error)")
        }
    }
    
    func insertList(listText : String){
        let insert = self.listTable.insert(self.listName <- listText)
        do{
            let rowID = try self.db!.run(insert)
            print(rowID)
        } catch {
            print("Cannot insert into database: \(error)")
        }
    }
    
    func loadToDoTable(listID : Int64) -> [ToDoItem] {
        var toDosArray = [ToDoItem]()
        do {
            for toDo in try  db!.prepare(toDoTable.filter(self.toDoListID == listID)) {
                let toDoAdd = toDo[self.toDo]
                let toDoIDAdd = toDo[self.toDoID]
                let toDoListIDAdd = listID
                let toDoCheckedAdd = toDo[self.toDoChecked] ?? 0
                let toDoItem = ToDoItem(text: toDoAdd!, list: toDoListIDAdd, id: toDoIDAdd, checked: toDoCheckedAdd)
                toDosArray.append(toDoItem)
            }
        } catch {
            print("Cannot load database: \(error)")
        }
        return toDosArray
    }
    
    func loadListTable() -> [ListItem] {
        var listsArray = [ListItem]()
        do {
            for list in try db!.prepare(listTable) {
                let idAdd = list[self.listID]
                let listAdd = list[self.listName]

                let listItem = ListItem(id: idAdd, name: listAdd)
                listsArray.append(listItem)
            }
        } catch {
            print("Cannot load database: \(error)")
        }
        return listsArray
    }
    
    func deleteToDo(ID : Int64) {
        let toDoDelete = toDoTable.filter(toDoID == ID)
        do {
            if try db!.run(toDoDelete.delete()) > 0 {
                print("deleted to do")
            } else {
                print("to do not found")
            }
        } catch {
            print("delete failed: \(error)")
        }
    }
    
    
    func deleteList(ID : Int64) {
        print("check: delete")
        let listDelete = listTable.filter(listID == ID)
        do {
            if try db!.run(listDelete.delete()) > 0 {
                print("deleted list")
            } else {
                print("to list found")
            }
        } catch {
            print("delete failed: \(error)")
        }
    }
    func updateToDoChecked(ID : Int64, checked: Int64) {
        do{
            print("IDcheck: \(ID)")
            
            try db!.run(toDoTable.filter(toDoID == ID).update(toDoChecked <- checked))
        } catch {
            print("update failed: \(error)")
        }
    }
    
    func loadSwitchstate(ID : Int64) -> Int64{
        var checked : Int64 = 0
        do{
            
            for toDo in try db!.prepare(toDoTable.select(toDoChecked)){
                if toDo[toDoChecked] != nil{
                    checked = toDo[toDoChecked]!
                }
                else {
                    checked = 0
                }
            }
            
        } catch {
            print("could not load switchstate\(error)")
        }
        return checked
    }

        static let shared = ToDoManager()
}

    
