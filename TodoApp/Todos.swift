//
//  Todos.swift
//  TodoApp
//
//  Created by 정종원 on 5/24/24.
//

import Foundation

class Todos {
    var todoTitle: String
    var todoisChecked: Bool
    
    init(todoTitle: String, todoisChecked: Bool) {
        self.todoTitle = todoTitle
        self.todoisChecked = todoisChecked
    }
}
