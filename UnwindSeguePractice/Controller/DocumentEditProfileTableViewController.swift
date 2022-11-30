//
//  DocumentEditProfileTableViewController.swift
//  UnwindSeguePractice
//
//  Created by 羅以捷 on 2022/11/29.
//

import UIKit

class DocumentEditProfileTableViewController: UITableViewController {
    var profile : ProfileItem?
    var isMale = true
    var birthday: Date = Date.now
    var isSelectingPhoto : Bool = false
    
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var selectedPhotoButton: UIButton!
    @IBOutlet weak var profileNameTextField: UITextField!
    @IBOutlet weak var profilePhoneTextField: UITextField!
    @IBOutlet weak var profileHeightTextField: UITextField!
    @IBOutlet weak var profileWeightTextField: UITextField!
    @IBOutlet weak var profileBirthdayPicker: UIDatePicker!
    @IBOutlet weak var zodiacSignLabel: UILabel!
    
    @IBOutlet var genderButtons: [UIButton]!
    
    @IBAction func selectedPhotoButtonAction(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    
    @IBAction func maleButtonAction(_ sender: Any) {
        genderButtons[0].setImage(UIImage(named: "check"), for: .normal)
        genderButtons[1].setImage(UIImage(named: "uncheck"), for: .normal)
        isMale = true
    }
    
    @IBAction func femaleButtonAction(_ sender: Any) {
        genderButtons[0].setImage(UIImage(named: "uncheck"), for: .normal)
        genderButtons[1].setImage(UIImage(named: "check"), for: .normal)
        isMale = false
    }
    
    func updateUI(){
        if let profile = profile {
            profileNameTextField.text = profile.name
            profilePhoneTextField.text = profile.phone
            profileHeightTextField.text = profile.height.description
            profileWeightTextField.text = profile.weight.description
            zodiacSignLabel.text = profile.zodiacSign
            isMale = profile.isMale
            profileBirthdayPicker.date = profile.birthday
            updateZodiacSign(profileBirthdayPicker.date)
            if let imageData = profile.imageData{
                selectedPhotoButton.setTitle(nil, for: .normal)
                selectedImageView.image = UIImage(data: imageData)
            }
        } else {
            updateZodiacSign(Date.now)
        }
    }
    
    func updateZodiacSign(_ date : Date){
        let zodiac = ZodiacSign.self
        let current = Calendar.current
        let month = current.component(.month, from: date)
        let day = current.component(.day, from: date)
        switch month {
            case 1 :
                zodiacSignLabel.text = day > 20 ? zodiac.aquarius.rawValue : zodiac.capricorn.rawValue
            case 2 :
                zodiacSignLabel.text = day > 19 ? zodiac.pisces.rawValue : zodiac.aquarius.rawValue
            case 3 :
                zodiacSignLabel.text = day > 20 ? zodiac.aries.rawValue : zodiac.pisces.rawValue
            case 4 :
                zodiacSignLabel.text = day > 19 ? zodiac.taurus.rawValue : zodiac.aries.rawValue
            case 5 :
                zodiacSignLabel.text = day > 20 ? zodiac.gemini.rawValue : zodiac.taurus.rawValue
            case 6 :
                zodiacSignLabel.text = day > 21 ? zodiac.cancer.rawValue : zodiac.gemini.rawValue
            case 7 :
                zodiacSignLabel.text = day > 22 ? zodiac.leo.rawValue : zodiac.cancer.rawValue
            case 8 :
                zodiacSignLabel.text = day > 22 ? zodiac.virgo.rawValue : zodiac.leo.rawValue
            case 9 :
                zodiacSignLabel.text = day > 22 ? zodiac.libra.rawValue : zodiac.virgo.rawValue
            case 10 :
                zodiacSignLabel.text = day > 23 ? zodiac.scorpio.rawValue : zodiac.libra.rawValue
            case 11 :
                zodiacSignLabel.text = day > 21 ? zodiac.sagittarius.rawValue : zodiac.scorpio.rawValue
            default :
                zodiacSignLabel.text = day > 20 ? zodiac.capricorn.rawValue : zodiac.sagittarius.rawValue
        }
    }
    
    @IBAction func pickBirthday(_ sender: UIDatePicker) {
        birthday = sender.date
        updateZodiacSign(birthday)
    }
    
    override func viewDidLoad() {
        updateUI()
        let checkMale = isMale ? "check" : "uncheck"
        let checkFemale = !isMale ? "check" : "uncheck"
        genderButtons[0].setImage(UIImage(named: checkMale), for: .normal)
        genderButtons[1].setImage(UIImage(named: checkFemale), for: .normal)
        super.viewDidLoad()
    }


    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if !profileNameTextField.text!.isEmpty, !profilePhoneTextField.text!.isEmpty, let _ = Double(profileHeightTextField.text!), let _ = Double(profileWeightTextField.text!), !zodiacSignLabel.text!.isEmpty{
            return true
        } else {
            let alertController = UIAlertController(title: "錯誤", message: "請輸入正確資料", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .cancel)
            alertController.addAction(alertAction)
            present(alertController, animated: true)
            return false
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let name = profileNameTextField.text, let phoneNumber = profilePhoneTextField.text, let height = Double(profileHeightTextField.text!), let weight = Double(profileWeightTextField.text!), let zodiac = zodiacSignLabel.text, !name.isEmpty, !phoneNumber.isEmpty {
            var imageData : Data?
            if isSelectingPhoto {
                imageData = selectedImageView.image?.jpegData(compressionQuality: 0.8)
            }
            profile = ProfileItem(name: name, phone: phoneNumber, height: height, weight: weight, birthday: birthday, zodiacSign: zodiac, isMale: isMale, imageData: imageData)
        }
    }

}

extension DocumentEditProfileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectedPhotoButton.setTitle(nil, for: .normal)
        let image = info[.originalImage] as! UIImage
        selectedImageView.image = image
        isSelectingPhoto = true
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
