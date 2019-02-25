//
//  RepoTableViewCell.swift
//  L3-AutoLayout
//
//  Created by tran.duc.tan on 2/25/19.
//  Copyright © 2019 tran.duc.tanb. All rights reserved.
//

import UIKit

class RepoTableViewCell: UITableViewCell {
    
    @IBOutlet var containerView: UIView!
    @IBOutlet var imgViewUserAvt: UIImageView!
    @IBOutlet var lblRepoName: UILabel!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblDescription: UILabel!
    @IBOutlet var lblStarCnt: UILabel!
    @IBOutlet var btnFork: UIButton!
    @IBOutlet var btnClone: UIButton!
    
    var repository: Repository?
    
    var delegate: RepoTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowRadius = 1
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowOpacity = 0.4
        
        makeCustomLook(for: btnFork, with: UIColor(red: 147/255, green: 168/255, blue: 172/255, alpha: 1))
        makeCustomLook(for: btnClone, with: UIColor(red: 226/255, green: 180/255, blue: 189/255, alpha: 1))
    }
    
    func configure(for repo: Repository) {
        repository = repo
        
        lblRepoName.text = repository!.name
        lblUserName.text = repository!.username
        lblStarCnt.text = "\(repository!.starCnt) ⭐️"
        lblDescription.text = repository!.desc ?? ""
        
        if let urlUserAvt = repository!.urlUserAvt {
            let dataTask = URLSession.shared.dataTask(with: URL(string: urlUserAvt)!) { (data, response, error) in
                guard error == nil else {
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    guard httpResponse.statusCode == 200 else {
                        return
                    }
                    
                    if let receivedData = data {
                        let imgUserAvt = UIImage(data: receivedData)
                        
                        DispatchQueue.main.async {
                            self.imgViewUserAvt.image = imgUserAvt
                        }
                    }
                }
            }
            
            dataTask.resume()
        }
    }
    
    func makeCustomLook(for button: UIButton, with color: UIColor) {
        button.layer.backgroundColor = color.cgColor
        
        button.layer.cornerRadius = button.layer.frame.height / 2
        
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowRadius = 1
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
        button.layer.shadowOpacity = 0.4
    }
    
    @IBAction func onBtnForkTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.05, animations: {
            self.btnFork.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { completed in
            UIView.animate(withDuration: 0.05, animations: {
                self.btnFork.transform = CGAffineTransform.identity
            }, completion: { completed in
                self.delegate?.onBtnForkTapped(url: self.repository!.urlFork)
            })
        }
    }
    
    @IBAction func onBtnCloneTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.05, animations: {
            self.btnClone.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { completed in
            UIView.animate(withDuration: 0.05, animations: {
                self.btnClone.transform = CGAffineTransform.identity
            }, completion: { completed in
                self.delegate?.onBtnCloneTapped(url: self.repository!.urlClone)
            })
        }
    }
    
}

protocol RepoTableViewCellDelegate {
    func onBtnForkTapped(url: String)
    func onBtnCloneTapped(url: String)
}
