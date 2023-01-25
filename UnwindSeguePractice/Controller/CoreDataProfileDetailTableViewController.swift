//
//  CoreDataProfileDetailTableViewController.swift
//  UnwindSeguePractice
//
//  Created by 羅以捷 on 2023/1/24.
//

import UIKit

class CoreDataProfileDetailTableViewController: UITableViewController {
    
    var profile : ProfileItemOfCoreData!
    
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profilePhoneLabel: UILabel!
    @IBOutlet weak var genderLebel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var zodiacSignLabel: UILabel!
    @IBOutlet weak var heightLabel: UILabel!
    @IBOutlet weak var weightLabel: UILabel!
    
    func updateUI(){
        if let profile = profile {
            profileNameLabel.text = profile.name
            profilePhoneLabel.text = profile.phone
            genderLebel.text = profile.isMale ? "男性" : "女性"
            let dateformatter = DateFormatter()
            dateformatter.dateFormat = "yyyy-MM-dd"
            birthdayLabel.text = dateformatter.string(from: profile.birthday)
            zodiacSignLabel.text = profile.zodiacSign
            heightLabel.text = profile.height.description
            weightLabel.text = profile.weight.description
            if let imageData = profile.imageData{
                selectedImageView.image = UIImage(data: imageData)
            }
        }
    }

    override func viewDidLoad() {
        updateUI()
        super.viewDidLoad()

    }



    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? CoreDataEditProfileTableViewController {
            destination.isNewProfile = false
            destination.profile = profile
        }
    }

}
