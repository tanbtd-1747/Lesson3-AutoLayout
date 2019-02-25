//
//  ViewController.swift
//  L3-AutoLayout
//
//  Created by tran.duc.tan on 2/20/19.
//  Copyright © 2019 tran.duc.tanb. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var tblRepos: UITableView!
    
    var repositories = [Repository]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(onBtnSearchTapped))
        
        tblRepos.dataSource = self
        tblRepos.delegate = self
        tblRepos.register(UINib(nibName: "RepoTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "repoCell")
        
        tblRepos.rowHeight = UITableView.automaticDimension
        tblRepos.estimatedRowHeight = 154
        tblRepos.allowsSelection = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            [weak self] in
            guard let self = self else {
                return
            }
            
            self.navigationItem.prompt = "Click the Search button!"
            self.navigationController?.viewIfLoaded?.setNeedsLayout()
        }
    }

}

// MARK: - Handling events
extension ViewController {
    @objc func onBtnSearchTapped() {
        let alertController = UIAlertController(title: "Search", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Enter Github username"
        }
        alertController.addAction(UIAlertAction(title: "Search", style: .default, handler: { [weak self] action in
            let textField = alertController.textFields![0] as UITextField
            let searchText = textField.text ?? ""
            self?.search(for: searchText)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true)
    }
    
    func search(for username: String) {
        repositories = []
        let urlGithubAPI = URL(string: "https://api.github.com/users/\(username)/repos")
        
        let dataTask = URLSession.shared.dataTask(with: urlGithubAPI!) { (data, response, error) in
            guard error == nil else {
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                guard httpResponse.statusCode == 200 else {
                    return
                }
                
                if let receivedData = data {
                    do {
                        let jsonResult = try JSONSerialization.jsonObject(with: receivedData, options: .mutableLeaves)
                        if let jsonResult = jsonResult as? [[String: AnyObject]] {
                            for repoResult in jsonResult {
                                let repoName = repoResult["name"] as! String
                                let repoUsername = repoResult["owner"]?["login"] as! String
                                let repoDesc = repoResult["description"] as? String
                                let repoUrlUserAvt = repoResult["owner"]?["avatar_url"] as? String
                                let repoUrlFork = repoResult["forks_url"] as! String
                                let repoUrlClone = repoResult["clone_url"] as! String
                                let repoStarCnt = repoResult["stargazers_count"] as! Int
                                
                                let repo = Repository(urlUserAvt: repoUrlUserAvt, name: repoName, username: repoUsername, desc: repoDesc, starCnt: repoStarCnt, urlFork: repoUrlFork, urlClone: repoUrlClone)
                                self.repositories.append(repo)
                            }
                        }
                    } catch {
                        print(error)
                    }
                    
                    DispatchQueue.main.async {
                        [weak self] in
                        guard let self = self else {
                            return
                        }
                        
                        self.navigationItem.title = username
                        self.tblRepos.reloadData()
                    }
                }
            }
        }
        
        dataTask.resume()
    }
}

// MARK: - TableView Data Source
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath) as! RepoTableViewCell
        cell.delegate = self
        cell.configure(for: repositories[indexPath.row])
        return cell
    }
}

// MARK: - TableView Delegate
extension ViewController: UITableViewDelegate {
    
}

// MARK: - RepoTableViewCellDelegate
extension ViewController: RepoTableViewCellDelegate {
    func onBtnForkTapped(url: String) {
        let alertController = UIAlertController(title: "Fork URL", message: url, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Copy to Clipboard", style: .default, handler: { (action) in
            UIPasteboard.general.string = url
            alertController.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true)
    }
    
    func onBtnCloneTapped(url: String) {
        let alertController = UIAlertController(title: "Clone URL", message: url, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Copy to Clipboard", style: .default, handler: { (action) in
            UIPasteboard.general.string = url
            alertController.dismiss(animated: true, completion: nil)
        }))
        present(alertController, animated: true)
    }
}
