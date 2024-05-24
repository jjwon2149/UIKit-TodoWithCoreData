//
//  ViewController.swift
//  TodoApp
//
//  Created by 정종원 on 5/24/24.
//

import UIKit

class ViewController: UIViewController {
    
    var todos = [Todos]()
    var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Todo"
        
        let rightBarButtonItem = UIBarButtonItem(title: "", image: UIImage(systemName: "plus"), target: self, action: #selector(rightBarButtonTapped))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ToDoCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    @objc func rightBarButtonTapped() {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "새 할일", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "할일 추가", style: .default) { (action) in
            let newTodo = Todos(todoTitle: textField.text!, todoisChecked: false)
            self.todos.append(newTodo)
            print(self.todos)
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "새 할일을 여기에 적어주세요"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        todos[indexPath.row].todoisChecked.toggle()
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath)
        let todo = todos[indexPath.row]
        cell.selectionStyle = .none
        cell.textLabel?.text = todo.todoTitle
        cell.accessoryType = todo.todoisChecked ? .checkmark : .none
        return cell
    }
    
    
}

