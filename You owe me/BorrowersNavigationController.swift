//
//  BorrowersNavigationController.swift
//  You owe me
//
//  Created by тигренок  on 16/08/2016.
//  Copyright © 2016 Iablonskyi Ievgenii. All rights reserved.
//

import UIKit

class BorrowersNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set colors.
        let navigationBar = self.navigationBar
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = BorrowingConstants.NavBarColor
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationBar.tintColor = UIColor.white
    }

  
}
