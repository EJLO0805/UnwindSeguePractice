//
//  ProfileDetailTableViewController.swift
//  UnwindSeguePractice
//
//  Created by 羅以捷 on 2022/11/26.
//

import UIKit

class ProfileDetailTableViewController: UITableViewController {
    
    var profile : ProfileItem?
    
    @IBOutlet weak var profileNameLabel: UILabel!
    @IBOutlet weak var profilePhoneLabel: UILabel!
    @IBOutlet weak var genderLebel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var ZodiacSignLabel: UILabel!
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
            ZodiacSignLabel.text = profile.zodiacSign
            heightLabel.text = profile.height.description
            weightLabel.text = profile.weight.description
        }
    }
    
    override func viewDidLoad() {
        updateUI()
        super.viewDidLoad()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editController = segue.destination as? EditProfileTableViewController {
            editController.profile = profile
        }
    }
}
