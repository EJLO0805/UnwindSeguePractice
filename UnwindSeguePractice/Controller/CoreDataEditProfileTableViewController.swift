//
//  CoreDataEditProfileTableViewController.swift
//  UnwindSeguePractice
//
//  Created by 羅以捷 on 2023/1/24.
//

import UIKit

class CoreDataEditProfileTableViewController: UITableViewController {
    
    var profile : ProfileItemOfCoreData!
    var isNewProfile = true
    var isMale = true
    var birthday: Date = Date.now
    var isSelectingPhoto : Bool = false
    
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var selectedImageButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var zodiacSignLabel: UILabel!
    @IBOutlet var genderButtons: [UIButton]!
    
    @IBAction func selectedImageButton(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true)
    }
    
    @IBAction func pickBirthday(_ sender: UIDatePicker) {
        birthday = sender.date
        zodiacSignLabel.text = ZodiacSign.updateZodiacSign(birthday)
    }
    @IBAction func isMaleButton(_ sender: Any) {
        genderButtons[0].setImage(UIImage(named: "check"), for: .normal)
        genderButtons[1].setImage(UIImage(named: "uncheck"), for: .normal)
        isMale = true
    }
    @IBAction func isFemaleButton(_ sender: Any) {
        genderButtons[0].setImage(UIImage(named: "uncheck"), for: .normal)
        genderButtons[1].setImage(UIImage(named: "check"), for: .normal)
        isMale = false
    }
    
    func updateUI(){
        if let profile = profile {
            nameTextField.text = profile.name
            phoneTextField.text = profile.phone
            heightTextField.text = profile.height.description
            weightTextField.text = profile.weight.description
            zodiacSignLabel.text = profile.zodiacSign
            isMale = profile.isMale
            datePicker.date = profile.birthday
            zodiacSignLabel.text = ZodiacSign.updateZodiacSign(datePicker.date)
            if let imageData = profile.imageData {
                selectedImageButton.setTitle(nil, for: .normal)
                selectedImageView.image = UIImage(data: imageData)
            }
        } else {
            zodiacSignLabel.text = ZodiacSign.updateZodiacSign(Date.now)
        }
    }
    
    override func viewDidLoad() {
        zodiacSignLabel.text = ZodiacSign.updateZodiacSign(birthday)
        updateUI()
        super.viewDidLoad()
    }
    
    
    @IBAction func saveProfile(_ sender: Any) {
        guard !nameTextField.text!.isEmpty , !phoneTextField.text!.isEmpty, let height = Double(heightTextField.text!), let weight = Double(weightTextField.text!) else {
            let alertController = UIAlertController(title: "錯誤", message: "請輸入正確資料", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .cancel)
            alertController.addAction(alertAction)
            present(alertController, animated: true)
            return
        }
        
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            if isNewProfile {
                profile = ProfileItemOfCoreData(context: appDelegate.persistentContainer.viewContext)
            }
            profile.name = nameTextField.text!
            profile.phone = phoneTextField.text!
            profile.height = height
            profile.weight = weight
            profile.birthday = datePicker.date
            profile.zodiacSign = zodiacSignLabel.text!
            profile.isMale = isMale
            if let imageData = selectedImageView.image?.jpegData(compressionQuality: 1){
                profile.imageData = imageData
            }
            appDelegate.saveContext()
        }
        isNewProfile = true
        self.navigationController?.popToRootViewController(animated: true)
    }

}


extension CoreDataEditProfileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectedImageButton.setTitle(nil, for: .normal)
        let image = info[.originalImage] as! UIImage
        selectedImageView.image = image
        isSelectingPhoto = true
        dismiss(animated: true)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
