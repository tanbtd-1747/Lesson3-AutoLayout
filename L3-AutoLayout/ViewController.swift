//
//  ViewController.swift
//  L3-AutoLayout
//
//  Created by tran.duc.tan on 2/20/19.
//  Copyright © 2019 tran.duc.tanb. All rights reserved.
//

import UIKit
import UserNotifications
import CoreData

class ViewController: UIViewController {
    
    @IBOutlet var tblPeople: UITableView!
    
    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onBtnAddTapped))
        
        tblPeople.dataSource = self
        tblPeople.delegate = self
        
        UNUserNotificationCenter.current().delegate = self
        
        fetchData()
    }
    
    private func requestNotificationAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            completionHandler(success)
        }
    }
    
    private func scheduleLocalNotification(title: String, body: String) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 10, repeats: false)
        let notificationRequest = UNNotificationRequest(identifier: "coredata_local_notification", content: notificationContent, trigger: notificationTrigger)
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }

}

// MARK: - Handling events
extension ViewController {
    @objc func onBtnAddTapped() {
        let alertController = UIAlertController(title: "Add a person", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
            textField.keyboardType = .asciiCapable
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Age"
            textField.keyboardType = .asciiCapableNumberPad
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "City"
            textField.keyboardType = .asciiCapable
        }
        alertController.addAction(UIAlertAction(title: "Add", style: .default, handler: { (action) in
            let tfName = alertController.textFields![0]
            let tfAge = alertController.textFields![1]
            let tfCity = alertController.textFields![2]
            
            if let name = tfName.text, let age = tfAge.text, let city = tfCity.text {
                self.saveData(name: name, age: Int16(age) ?? 0, city: city)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
    
    func onSelectRow(at indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Edit a person", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.text = self.people[indexPath.row].name
            textField.keyboardType = .asciiCapable
        }
        alertController.addTextField { (textField) in
            textField.text = "\(self.people[indexPath.row].age)"
            textField.keyboardType = .asciiCapableNumberPad
        }
        alertController.addTextField { (textField) in
            textField.text = self.people[indexPath.row].city
            textField.keyboardType = .asciiCapable
        }
        alertController.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (action) in
            let tfName = alertController.textFields![0]
            let tfAge = alertController.textFields![1]
            let tfCity = alertController.textFields![2]
            
            if let name = tfName.text, let age = tfAge.text, let city = tfCity.text {
                self.updateData(at: indexPath, name: name, age: Int16(age) ?? 0, city: city)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
}

// MARK: - Core Data functions
extension ViewController {
    func fetchData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = Person.createFetchRequest()
        
        do {
            people = try managedContext.fetch(request)
            tblPeople.reloadData()
        } catch {
            print("Fetch failed")
        }
    }
    
    func saveData(name: String, age: Int16, city: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let person = Person(context: managedContext)
        person.name = name
        person.age = age
        person.city = city
        
        do {
            try managedContext.save()
            
            UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
                switch notificationSettings.authorizationStatus {
                case .notDetermined:
                    self.requestNotificationAuthorization(completionHandler: { (success) in
                        guard success else {
                            return
                        }
                        self.scheduleLocalNotification(title: "Added a Person", body: "\(name) - \(age) - \(city)")
                    })
                case .authorized:
                    self.scheduleLocalNotification(title: "Added a Person", body: "\(name) - \(age) - \(city)")
                case .denied:
                    print("Application Not Allowed to Display Notifications")
                case .provisional:
                    print("Application is provisionally allowed to post noninterrputive user notifications")
                }
            }
            
            fetchData()
        } catch {
            print("Save failed")
        }
    }
    
    func updateData(at indexPath: IndexPath, name: String, age: Int16, city: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = Person.createFetchRequest()
        request.predicate = NSPredicate(format: "name = %@", people[indexPath.row].name)
        
        do {
            let peopleToUpdate = try managedContext.fetch(request)
            let personToUpdate = peopleToUpdate[0] as NSManagedObject
            personToUpdate.setValue(name, forKey: "name")
            personToUpdate.setValue(age, forKey: "age")
            personToUpdate.setValue(city, forKey: "city")
            
            do {
                try managedContext.save()
                
                UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
                    switch notificationSettings.authorizationStatus {
                    case .notDetermined:
                        self.requestNotificationAuthorization(completionHandler: { (success) in
                            guard success else {
                                return
                            }
                            self.scheduleLocalNotification(title: "Editted a Person", body: "\(name) - \(age) - \(city)")
                        })
                    case .authorized:
                        self.scheduleLocalNotification(title: "Editted a Person", body: "\(name) - \(age) - \(city)")
                    case .denied:
                        print("Application Not Allowed to Display Notifications")
                    case .provisional:
                        print("Application is provisionally allowed to post noninterrputive user notifications")
                    }
                }
                
                fetchData()
            } catch {
                print("Save failed")
            }
        } catch {
            print("Delete failed")
        }
    }
    
    func deleteData(at indexPath: IndexPath) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = Person.createFetchRequest()
        request.predicate = NSPredicate(format: "name = %@", people[indexPath.row].name)
        
        let personToDeleteName = people[indexPath.row].name
        let personToDeleteAge = people[indexPath.row].age
        let personToDeleteCity = people[indexPath.row].city
        
        do {
            let peopleToDelete = try managedContext.fetch(request)
            let personToDelete = peopleToDelete[0] as NSManagedObject
            managedContext.delete(personToDelete)
            
            do {
                try managedContext.save()
                
                UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
                    switch notificationSettings.authorizationStatus {
                    case .notDetermined:
                        self.requestNotificationAuthorization(completionHandler: { (success) in
                            guard success else {
                                return
                            }
                            self.scheduleLocalNotification(title: "Deleted a Person", body: "\(personToDeleteName) - \(personToDeleteAge) - \(personToDeleteCity)")
                        })
                    case .authorized:
                        self.scheduleLocalNotification(title: "Deleted a Person", body: "\(personToDeleteName) - \(personToDeleteAge) - \(personToDeleteCity)")
                    case .denied:
                        print("Application Not Allowed to Display Notifications")
                    case .provisional:
                        print("Application is provisionally allowed to post noninterrputive user notifications")
                    }
                }
                
                fetchData()
            } catch {
                print("Save failed")
            }
        } catch {
            print("Delete failed")
        }
    }
}

// MARK: - Table View Data Source
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = people[indexPath.row].name
        cell.detailTextLabel?.text = "\(people[indexPath.row].age) - \(people[indexPath.row].city)"
        return cell
    }
}

// MARK: - Table View Delegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            deleteData(at: indexPath)
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        onSelectRow(at: indexPath)
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension ViewController: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
}
