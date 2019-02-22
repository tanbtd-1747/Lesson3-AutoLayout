//
//  ViewController.swift
//  L3-AutoLayout
//
//  Created by tran.duc.tan on 2/20/19.
//  Copyright © 2019 tran.duc.tanb. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tfSearch: UITextField!
    
    private let refreshControl = UIRefreshControl()
    
    private var mockPeople = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readMockData()
        
        // Navigation Bar
        title = "People"

        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(onEditButtonTapped))
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(onAddButtonTapped))
        let kbButton = UIBarButtonItem(title: "Keyboard", style: .plain, target: self, action: #selector(onKeyboardButtonTapped))
        navigationItem.rightBarButtonItems = [addButton, kbButton]
        
        // Observe to keyboard notification
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        // Setup Table View
        tableView.dataSource = self
        tableView.delegate = self
        
        let cellNib = UINib(nibName: "CustomTableViewCell", bundle: Bundle.main)
        tableView.register(cellNib, forCellReuseIdentifier: "cell")
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            tableView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let destVC = segue.destination as! DetailsViewController
            destVC.person = mockPeople[sender as! Int]
        }
    }
    
    func readMockData() {
        if let path = Bundle.main.path(forResource: "MOCK_DATA", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let people = jsonResult["people"] as? [Dictionary<String, String>] {
                    for person in people {
                        mockPeople.append(Person(name: person["name"]!, university: person["university"]!, desc: person["description"]!))
                    }
                }
            } catch {
                return
            }
        }
    }
    
    @objc func refresh() {
        let newPerson = Person(name: "Kim Jong Un", university: "Stanford University", desc: "Nuke the world!")
        mockPeople.insert(newPerson, at: 0)
        
        tableView.reloadData()
        refreshControl.endRefreshing()
        
    }
    
    @objc func onEditButtonTapped() {
        tableView.isEditing = !tableView.isEditing
    }
    
    @objc func onKeyboardButtonTapped() {
        if tfSearch.isFirstResponder {
            tfSearch.resignFirstResponder()
        } else {
            tfSearch.becomeFirstResponder()
        }
    }
    
    @objc func onAddButtonTapped() {
        let newPerson = Person(name: "Donald Trump", university: "Havard Business School", desc: "Make America great again!")
        mockPeople.insert(newPerson, at: 0)
        tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let kbScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let kbViewEndFrame = view.convert(kbScreenEndFrame, to: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        } else {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: kbViewEndFrame.height, right: 0)
        }
        
        tableView.scrollIndicatorInsets = tableView.contentInset
        
        if let selectedRowIndexPath = tableView.indexPathsForSelectedRows?.first {
            tableView.scrollToRow(at: selectedRowIndexPath, at: .top, animated: true)
        }
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return mockPeople.count
        default:
            return 15
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
            cell.configure(for: mockPeople[indexPath.row])
            return cell
        default:
            let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
            cell.textLabel?.text = "Section \(indexPath.section) - Row \(indexPath.row)"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            tableView.deselectRow(at: indexPath, animated: true)
            performSegue(withIdentifier: "showDetail", sender: indexPath.row)
        case 1:
            tableView.deselectRow(at: indexPath, animated: true)
            if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
            } else {
                tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
            }
        default:
            return
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        if sourceIndexPath.section == 0 && destinationIndexPath.section == 0 {
            let movedPerson = mockPeople[sourceIndexPath.row]
            mockPeople.remove(at: sourceIndexPath.row)
            mockPeople.insert(movedPerson, at: destinationIndexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        switch indexPath.section {
        case 1:
            let alertAction = UITableViewRowAction(style: .default, title: "Alert") { (action, indexPath) in
                let alertController = UIAlertController(title: "Test UITableViewRowAction", message: "Section \(indexPath.section) - Row \(indexPath.row)", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
            return [alertAction]
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard indexPath.section == 0 else {
            return
        }
        
        switch editingStyle {
        case .delete:
            mockPeople.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        default:
            return
        }
    }
    
}
