//
//  ViewController.swift
//  L3-AutoLayout
//
//  Created by tran.duc.tan on 2/20/19.
//  Copyright © 2019 tran.duc.tanb. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let redView = UIView()
        let blueView = UIView()
        let greenView = UIView()
        let orangeView = UIView()
        let whiteView = UIView()
        
        redView.backgroundColor = .red
        blueView.backgroundColor = .blue
        greenView.backgroundColor = .green
        orangeView.backgroundColor = .orange
        whiteView.backgroundColor = .white
        
        view.addSubview(redView)
        view.addSubview(blueView)
        view.addSubview(orangeView)
        view.addSubview(greenView)
        view.addSubview(whiteView)
        
        redView.translatesAutoresizingMaskIntoConstraints = false
        blueView.translatesAutoresizingMaskIntoConstraints = false
        greenView.translatesAutoresizingMaskIntoConstraints = false
        orangeView.translatesAutoresizingMaskIntoConstraints = false
        whiteView.translatesAutoresizingMaskIntoConstraints = false
        
        // Red View
        view.addConstraints([NSLayoutConstraint(item: redView, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1.0, constant: 0),
                             NSLayoutConstraint(item: redView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0),
                             NSLayoutConstraint(item: redView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1.0, constant: 0),
                             NSLayoutConstraint(item: redView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.5, constant: 0)])
        
        // Blue View
        view.addConstraints([NSLayoutConstraint(item: blueView, attribute: .top, relatedBy: .equal, toItem: redView, attribute: .bottom, multiplier: 1.0, constant: 0),
                             NSLayoutConstraint(item: blueView, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1.0, constant: 0),
                             NSLayoutConstraint(item: blueView, attribute: .width, relatedBy: .equal, toItem: redView, attribute: .width, multiplier: 0.5, constant: 0),
                             NSLayoutConstraint(item: blueView, attribute: .height, relatedBy: .equal, toItem: redView, attribute: .height, multiplier: 1.0, constant: 0)])
        
        // Orange View
        view.addConstraints([NSLayoutConstraint(item: orangeView, attribute: .top, relatedBy: .equal, toItem: redView, attribute: .bottom, multiplier: 1.0, constant: 0),
                             NSLayoutConstraint(item: orangeView, attribute: .leading, relatedBy: .equal, toItem: blueView, attribute: .trailing, multiplier: 1.0, constant: 0),
                             NSLayoutConstraint(item: orangeView, attribute: .width, relatedBy: .equal, toItem: blueView, attribute: .width, multiplier: 1.0, constant: 0),
                             NSLayoutConstraint(item: orangeView, attribute: .height, relatedBy: .equal, toItem: blueView, attribute: .height, multiplier: 0.5, constant: 0)])
        
        // Green View
        view.addConstraints([NSLayoutConstraint(item: greenView, attribute: .top, relatedBy: .equal, toItem: orangeView, attribute: .bottom, multiplier: 1.0, constant: 0),
                             NSLayoutConstraint(item: greenView, attribute: .leading, relatedBy: .equal, toItem: blueView, attribute: .trailing, multiplier: 1.0, constant: 0),
                             NSLayoutConstraint(item: greenView, attribute: .width, relatedBy: .equal, toItem: orangeView, attribute: .width, multiplier: 0.5, constant: 0),
                             NSLayoutConstraint(item: greenView, attribute: .height, relatedBy: .equal, toItem: orangeView, attribute: .height, multiplier: 1.0, constant: 0)])

        // White View
        view.addConstraints([NSLayoutConstraint(item: whiteView, attribute: .top, relatedBy: .equal, toItem: orangeView, attribute: .bottom, multiplier: 1.0, constant: 0),
                             NSLayoutConstraint(item: whiteView, attribute: .leading, relatedBy: .equal, toItem: greenView, attribute: .trailing, multiplier: 1.0, constant: 0),
                             NSLayoutConstraint(item: whiteView, attribute: .width, relatedBy: .equal, toItem: greenView, attribute: .width, multiplier: 1.0, constant: 0),
                             NSLayoutConstraint(item: whiteView, attribute: .height, relatedBy: .equal, toItem: greenView, attribute: .height, multiplier: 1.0, constant: 0)])
        
        
    }


}

