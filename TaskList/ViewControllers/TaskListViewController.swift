//
//  ViewController.swift
//  TaskList
//
//  Created by Ilya Zemskov on 02.04.2023.
//

import UIKit
import CoreData

final class TaskListViewController: UITableViewController {
    
    private let cellID = "task"
    private var taskList: [Task] = []
    private let storageManager = StorageManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        taskList = storageManager.fetchData()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
    }
    
    private func addNewTask() {
        createAlert()
    }
   
    private func createAlert(task: Task? = nil, completion: (() -> Void)? = nil) {
        let title = task != nil ? "Update Task" : "New Task"

        let alert = AlertController(
            title: title,
            message: "What do you want to do?",
            preferredStyle: .alert
        )

        alert.action(task: task) { [weak self] taskName in
            if let task = task, let completion = completion {
                self?.storageManager.edit(task, newTitle: taskName)
                completion()
            } else {
                self?.save(taskName)
            }
        }

        present(alert, animated: true)
    }
    
    private func save(_ taskName: String) {
        let task = Task(context: storageManager.viewContext)
        task.title = taskName
        taskList.append(task)
        
        let indexPath = IndexPath(row: taskList.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        
        if storageManager.viewContext.hasChanges {
            do {
                try storageManager.viewContext.save()
            } catch {
                print(error)
            }
        }
    }
    
    private func edit(_ taskName: String, _ indexPath: IndexPath) {
        storageManager.edit(taskList[indexPath.row], newTitle: taskName)
        taskList[indexPath.row].title = taskName
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

// MARK: - Setup UI
private extension TaskListViewController {
    func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.backgroundColor = UIColor(named: "MilkBlue")
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            systemItem: .add,
            primaryAction: UIAction { [unowned self] _ in
                addNewTask()
            }
        )
        navigationController?.navigationBar.tintColor = .white
    }
}

// MARK: - UITableViewDataSource
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = taskList[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = task.title
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            storageManager.delete(taskList[indexPath.row])
            taskList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        createAlert(task: taskList[indexPath.row]) {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}
