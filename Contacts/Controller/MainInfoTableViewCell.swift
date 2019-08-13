//
//  MainInfoTableViewCell.swift
//  Contacts
//
//  Created by Ruslan Kasian on 8/11/19.
//  Copyright © 2019 Ruslan Kasian. All rights reserved.
//

import UIKit

class MainInfoTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var photoOutlet: UIImageView!
    @IBOutlet weak var firstNameOutlet: UITextField!
    @IBOutlet weak var lastNameOutlet: UITextField!
    
    var initType: InitType? {
        didSet {
            switch initType {
            case .create?, .edite?:
                editeStyleSetup ()
            case .show?:
               showStyleSetup ()
            case .none:
                showStyleSetup ()
            }
        }
    }
    weak var vc: PersonTableViewController?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupPhoto ()
        
    }

    func setupPhoto () {
        photoOutlet.isUserInteractionEnabled = true
        photoOutlet.clipsToBounds = true
        photoOutlet.layer.cornerRadius  = 8
        photoOutlet.layer.borderColor = UIColor.lightGray.cgColor
        photoOutlet.layer.borderWidth = 0.5
    }
    
    func editeStyleSetup (){
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(editeUserPhoto))
        self.photoOutlet.addGestureRecognizer(tapGestureRecognizer)
        firstNameOutlet.isEnabled = true
        lastNameOutlet.isEnabled = true
    }
    
    func showStyleSetup (){
        firstNameOutlet.isEnabled = false
        lastNameOutlet.isEnabled = false

    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

    @objc private func editeUserPhoto () {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        self.vc?.present(picker, animated: true, completion: nil)
    }
}

//MARK: Image Picker -----------------------------------------------------------------

extension MainInfoTableViewCell: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] {
            selectedImageFromPicker = editedImage as? UIImage
            
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] {
            selectedImageFromPicker = originalImage as? UIImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            photoOutlet.image = selectedImage
            self.vc?.profileImage = selectedImage 
        }
        self.vc?.dismiss(animated: true, completion: nil)
    }
}
