//
//  EditProfileViewController.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 08.10.2020.
//

import UIKit

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
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

    // MARK: - UIImagePickerController
extension EditProfileViewController {
    
    func configImagePicker() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = ["public.image", "public.movie"]
        pickerController.sourceType = .camera
    }
}
