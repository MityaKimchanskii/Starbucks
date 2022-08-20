//
//  ViewController.swift
//  Starbucks
//
//  Created by Mitya Kim on 8/19/22.
//

import UIKit

class HomeViewController: StarBukcsViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Good afternoon, Dima 🌞"
        
        setTabBarImage(imageName: "house.fill", title: "Home")
    }
}

