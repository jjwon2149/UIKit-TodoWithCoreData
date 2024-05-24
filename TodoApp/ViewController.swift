//
//  ViewController.swift
//  TodoApp
//
//  Created by 정종원 on 5/24/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var todos = [TodoModel]()
    var tableView = UITableView()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
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
        
        let action = UIAlertAction(title: "할일 추가", style: .default) { action in
            
            
            let newTodo = TodoModel(context: self.context)
            newTodo.todoTitle = textField.text
            newTodo.todoisChecked = false
            
            self.todos.append(newTodo)
            self.saveData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "새 할일을 여기에 적어주세요"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - CoreData Method
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error: \(error)")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func loadData(with request: NSFetchRequest<TodoModel> = TodoModel.fetchRequest()) {
        
        do {
            todos = try context.fetch(request)
        } catch {
            print("Error loading Categories \(error)")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}
//MARK: - TableView Delegate Method
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        todos[indexPath.row].todoisChecked.toggle()
        saveData()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let todoToRemove = todos[indexPath.row]
            context.delete(todoToRemove)
            todos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            saveData()
        }
    }
}

//MARK: - TableView Datasource Method
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

