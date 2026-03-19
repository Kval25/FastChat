//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    
    // to hide the navigation bar
    override func viewWillAppear(_ animated: Bool) {
        // its a good to call super class after we override func. in superclass
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    // to unhide after the welcome screen.
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    

}
