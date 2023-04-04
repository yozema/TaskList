//
//  StorageManager.swift
//  TaskList
//
//  Created by Ilya Zemskov on 04.04.2023.
//

import CoreData

final class StorageManager {
    
    static let shared = StorageManager()
    private init() {}
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TaskList")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Fetch Tasks
    func fetchData() -> [Task] {
        let fetchRequest = Task.fetchRequest()
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
        return []
    }
    
    // MARK: - Edit Task
    func edit(_ task: Task, newTitle: String) {
        task.title = newTitle
        saveContext()
    }
    
    // MARK: - Delete Task
    func delete(_ task: Task) {
        viewContext.delete(task)
        saveContext()
    }
}
