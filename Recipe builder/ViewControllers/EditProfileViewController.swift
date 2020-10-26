//
//  EditProfileViewController.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 08.10.2020.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    // MARK: - IB Outlet
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var surNameTextField: UITextField!

    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    }

}
