//
//  ContactTableViewCell.swift
//  Contacts
//
//  Created by Ruslan Kasian on 8/11/19.
//  Copyright © 2019 Ruslan Kasian. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var contactPhotoOutlet: UIImageView!
    
    @IBOutlet weak var fullNameOutlet: UILabel!
    
    var personInfo: Person? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = personInfo,
            let contactPhoto = contactPhotoOutlet,
            let fullName = fullNameOutlet,
            let firstName = personInfo?.firstName,
            let lastName = personInfo?.lastName{
            
            fullName.text = "\(firstName) \(lastName)"
            if let imageData = detail.profileImage {
                contactPhoto.image = UIImage(data: imageData as Data)
            }else {
                contactPhoto.image = UIImage(named: "personaPlaceholder")
            }
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupPhoto ()

    }
    
    func setupPhoto () {

        contactPhotoOutlet.clipsToBounds = true
        contactPhotoOutlet.layer.cornerRadius  = contactPhotoOutlet.frame.width/2
        contactPhotoOutlet.layer.borderColor = UIColor.lightGray.cgColor
        contactPhotoOutlet.layer.borderWidth = 0.5
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
