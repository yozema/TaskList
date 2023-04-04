//
//  AlertController.swift
//  TaskList
//
//  Created by Ilya Zemskov on 04.04.2023.
//

import UIKit

class AlertController: UIAlertController {
    
    func action(task: Task?, completion: @escaping (String) -> Void) {
        let saveAction = UIAlertAction(title: "Save Task", style: .default) { _ in
            guard let task = self.textFields?.first?.text, !task.isEmpty else { return }
            completion(task)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        addAction(saveAction)
        addAction(cancelAction)
        addTextField { textField in
            textField.placeholder = "New Task"
            textField.text = task?.title
        }
    }
}
