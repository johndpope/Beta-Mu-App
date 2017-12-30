//
// Copyright 2014-2017 Amazon.com,
// Inc. or its affiliates. All Rights Reserved.
//
// Licensed under the Amazon Software License (the "License").
// You may not use this file except in compliance with the
// License. A copy of the License is located at
//
//     http://aws.amazon.com/asl/
//
// or in the "license" file accompanying this file. This file is
// distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
// CONDITIONS OF ANY KIND, express or implied. See the License
// for the specific language governing permissions and
// limitations under the License.
//

import Foundation
import AWSCognitoIdentityProvider
import AWSS3

class SignUpViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CropViewControllerDelegate, UIGestureRecognizerDelegate {
    
    var pool: AWSCognitoIdentityUserPool?
    var sentTo: String?
    
    private let imageView = UIImageView()
    private var image: UIImage?
    private var croppingStyle = CropViewCroppingStyle.default
    private var croppedRect = CGRect.zero
    private var croppedAngle = 0
    
    var year: String!
    var major: String!
    var pinNum: String!
    var brotherStatus: String!
    var proboLevel: String!
    var checked = Set<IndexPath>()
    var userHousePositions: [String]!
    var housePositions: String!  // String version
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var birthDate: UITextField!
    @IBOutlet weak var contactEmail: UITextField!
    @IBOutlet weak var phone: UITextField!
    @IBOutlet weak var streetAddress: UITextField!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var state: UITextField!
    @IBOutlet weak var zip: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    let transferManager = AWSS3TransferManager.default()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pool = AWSCognitoIdentityUserPool.init(forKey: AWSCognitoUserPoolsSignInProviderKey)
        
        
        // Set Delegates
        firstName.delegate = self
        lastName.delegate = self
        birthDate.delegate = self
        contactEmail.delegate = self
        phone.delegate = self
        streetAddress.delegate = self
        city.delegate = self
        state.delegate = self
        zip.delegate = self
        email.delegate = self
        username.delegate = self
        password.delegate = self
        confirmPassword.delegate = self
        
        // Mask User Photo
        userImage.layer.masksToBounds = false
        userImage.layer.cornerRadius = userImage.frame.height/2
        userImage.clipsToBounds = true
        
        userImage.isUserInteractionEnabled = true
        userImage.contentMode = .scaleAspectFit
        
        // Set Phone Prefix
        /* if phone.text == ""
        { phone.text = "+1" } */

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        print("year: \(year)")
        print("major: \(major)")
        print("Brother Status: \(brotherStatus)")
        print("Pin Number: \(pinNum)")
        print("Probo Level: \(proboLevel)")
        if(userHousePositions != nil) {
            housePositions = userHousePositions.joined(separator: ", ")
            print("House Positions: \(housePositions)")
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let signUpConfirmationViewController = segue.destination as? ConfirmSignUpViewController {
            signUpConfirmationViewController.sentTo = self.sentTo
            signUpConfirmationViewController.user = self.pool?.getUser(self.username.text!)
        }
        if segue.identifier == "registrationToYearMajorToSegue" {
            if let toViewController = segue.destination as? YearSelectionViewController {
                toViewController.year = self.year
                toViewController.major = self.major
            }
        }
        if segue.identifier == "registrationToBrotherStatusSegue" {
            if let toViewController = segue.destination as? BrotherStatusViewController {
                toViewController.pinNum = self.pinNum
                toViewController.brotherStatus = self.brotherStatus
            }
        }
        if segue.identifier == "registrationToProboLevelSegue" {
            if let toViewController = segue.destination as? ProboLevelViewController {
                toViewController.proboLevel = self.proboLevel
            }
        }
        if segue.identifier == "registrationToHousePositionsSegue" {
            if let toViewController = segue.destination as? HousePositionsTableViewController {
                toViewController.checked = self.checked
            }
        }
    }
    
    @IBAction func unwindFromYearMajor(_ sender: UIStoryboardSegue) {
        if sender.source is YearSelectionViewController {
            if let senderYM = sender.source as? YearSelectionViewController {
                year = senderYM.year
                major = senderYM.majorText.text
            }
        }
    }
    
    @IBAction func unwindFromBrotherStatus(_ sender: UIStoryboardSegue) {
        if sender.source is BrotherStatusViewController {
            if let senderBS = sender.source as? BrotherStatusViewController {
                brotherStatus = senderBS.brotherStatus
                pinNum = senderBS.pinNumber.text
            }
        }
    }
    
    @IBAction func unwindFromPoboLevel(_ sender: UIStoryboardSegue) {
        if sender.source is ProboLevelViewController {
            if let senderPL = sender.source as? ProboLevelViewController {
                proboLevel = senderPL.proboLevel
            }
        }
    }
    
    @IBAction func unwindFromHousePositions(_ sender: UIStoryboardSegue) {
        if sender.source is HousePositionsTableViewController {
            if let senderHP = sender.source as? HousePositionsTableViewController {
                checked = senderHP.checked
                userHousePositions = senderHP.userHousePositions
            }
        }
    }
    
    // MARK: Dealing With Keyboards
    @IBAction func textFieldDidBeginEditing(_ sender: UITextField) {
        if phone.text == ""
        { phone.text = "+1" }
    }
    
    @IBAction func birthDateFieldBeginEditing(_ sender: UITextField) {
        let slash: String = "/"
        
        if birthDate.text?.count == 2 || birthDate.text?.count == 5 {
            birthDate.text = birthDate.text! + slash
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignAllKeyboads()
        return false
    }
    
    func resignAllKeyboads() {
        // Hide the keyboard.
        firstName.resignFirstResponder()
        lastName.resignFirstResponder()
        birthDate.resignFirstResponder()
        contactEmail.resignFirstResponder()
        phone.resignFirstResponder()
        streetAddress.resignFirstResponder()
        city.resignFirstResponder()
        state.resignFirstResponder()
        zip.resignFirstResponder()
        email.resignFirstResponder()
        username.resignFirstResponder()
        password.resignFirstResponder()
        confirmPassword.resignFirstResponder()
    }
    
    // MARK: Format Convervsions
    func formatBirthDate(_ birthdate: String) -> String {
        let birthDateWithOutSlashes: String = birthdate.replacingOccurrences(of: "/", with: "", options: .literal, range: nil)
        print(birthDateWithOutSlashes)
        let monthIndex = birthDateWithOutSlashes.index(birthDateWithOutSlashes.startIndex, offsetBy: 2)
        let yearIndex = birthDateWithOutSlashes.index(birthDateWithOutSlashes.startIndex, offsetBy: 4)
        
        let month = birthDateWithOutSlashes[..<monthIndex]
        //print(month)
        let day = birthDateWithOutSlashes[monthIndex..<yearIndex]
        //print(day)
        let year = birthDateWithOutSlashes[yearIndex...]
        //print(year)
        let formatedBirthDate: String = String(year + "-" + month + "-" + day)
        //print(formatedBirthDate)
        return (formatedBirthDate)
    }
    
    func formatAddress(_ streetAddress: String, city: String, state: String, zip: String) -> String {
        
        let formattedAddress = streetAddress + " " + city + ", " + state + " " + zip
        print(formattedAddress)
        
        return formattedAddress
    }
    
    // MARK: Sign Up User
    @IBAction func signUp(_ sender: AnyObject) {
        
        var passwordsMatch = false
        
        guard let userNameValue = self.username.text, !userNameValue.isEmpty,
        let passwordValue = self.password.text, !passwordValue.isEmpty, let confirmPasswordValue = self.confirmPassword.text, !confirmPasswordValue.isEmpty
            else {
                let alertController = UIAlertController(title: "Missing Required Fields",
                                                        message: "Username/Password fields are required for registration.",
                                                        preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion:  nil)
                return
        }
        
        if(passwordValue != confirmPasswordValue) {
            let alertController = UIAlertController(title: "Passwords Don't Match",
                                                   message: "Password fields must match for registration.",
                                                   preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion:  nil)
        } else {
            passwordsMatch = true
        }
        
        // MARK: Default Attributes
        var attributes = [AWSCognitoIdentityUserAttributeType]()
        
        if let firstNameValue = self.firstName.text, !firstNameValue.isEmpty {
            let firstName = AWSCognitoIdentityUserAttributeType()
            firstName?.name = "given_name"
            firstName?.value = firstNameValue
            attributes.append(firstName!)
        }
        
        if let lastNameValue = self.lastName.text, !lastNameValue.isEmpty {
            let lastName = AWSCognitoIdentityUserAttributeType()
            lastName?.name = "family_name"
            lastName?.value = lastNameValue
            attributes.append(lastName!)
        }

        if var birthDateValue = self.birthDate.text, !birthDateValue.isEmpty {
            print("yo")
            birthDateValue = self.formatBirthDate(self.birthDate.text!)
            let birthDate = AWSCognitoIdentityUserAttributeType()
            birthDate?.name = "birthdate"
            birthDate?.value = birthDateValue
            attributes.append(birthDate!)
        }
        
        if let emailValue = self.email.text, !emailValue.isEmpty {
            let email = AWSCognitoIdentityUserAttributeType()
            email?.name = "email"
            email?.value = emailValue
            attributes.append(email!)
        }
        
        if let phoneValue = self.phone.text, !phoneValue.isEmpty {
            let phone = AWSCognitoIdentityUserAttributeType()
            phone?.name = "phone_number"
            phone?.value = phoneValue
            attributes.append(phone!)
        }
        
        if(self.streetAddress.text != "" && self.city.text != "" && self.state.text != "" && self.zip.text != "") {
            
            let addressValue = formatAddress(streetAddress.text!, city: city.text!, state: state.text!, zip: zip.text!)
            let address = AWSCognitoIdentityUserAttributeType()
            address?.name = "address"
            address?.value = addressValue
            attributes.append(address!)
        }
        
        // MARK: Custom Attribute
        if let contactEmailValue = self.contactEmail.text, !contactEmailValue.isEmpty {
            let contactEmail = AWSCognitoIdentityUserAttributeType()
            contactEmail?.name = "custom:contact_email"
            contactEmail?.value = contactEmailValue
            attributes.append(contactEmail!)
        }
        
        if let yearValue = self.year, !yearValue.isEmpty {
            let year = AWSCognitoIdentityUserAttributeType()
            year?.name = "custom:year"
            year?.value = yearValue
            attributes.append(year!)
        }
        
        if let majorValue = self.major, !majorValue.isEmpty {
            let major = AWSCognitoIdentityUserAttributeType()
            major?.name = "custom:major"
            major?.value = majorValue
            attributes.append(major!)
        }
        
        if let brotherStatusValue = self.brotherStatus, !brotherStatusValue.isEmpty {
            let brotherStatus = AWSCognitoIdentityUserAttributeType()
            brotherStatus?.name = "custom:brother_status"
            brotherStatus?.value = brotherStatusValue
            attributes.append(brotherStatus!)
        }
        
        if let pinNumValue = self.pinNum, !pinNumValue.isEmpty {
            let pinNum = AWSCognitoIdentityUserAttributeType()
            pinNum?.name = "custom:pin_number"
            pinNum?.value = pinNumValue
            attributes.append(pinNum!)
        }
        
        if let proboLevelValue = self.proboLevel, !proboLevelValue.isEmpty {
            let proboLevel = AWSCognitoIdentityUserAttributeType()
            proboLevel?.name = "custom:probo_level"
            if(proboLevelValue == "Not on Probo (GPA >= 2.85)") {
                proboLevel?.value = "0"
            }
            else if (proboLevelValue == "Probo 1 (2.85 > GPA >= 2.5)") {
                proboLevel?.value = "1"
            }
            else if (proboLevelValue == "Probo 2 (2.5 > GPA >= 2.0)") {
                proboLevel?.value = "2"
            }
            else if (proboLevelValue == "Probo 3 (2.0 > GPA)") {
                proboLevel?.value = "3"
            }
            proboLevel?.value = proboLevelValue
            attributes.append(proboLevel!)
        }
        
        if userHousePositions != nil {
            let userHousePositionsValue = userHousePositions.joined(separator: ", ")
            let housePositions = AWSCognitoIdentityUserAttributeType()
            housePositions?.name = "custom:house_positions"
            housePositions?.value = userHousePositionsValue
            attributes.append(housePositions!)
        }

        
        if passwordsMatch {
            
            let userInfoString: String = "First: \(firstName.text!)\nLast: \(lastName.text!)\nBirthday: \(birthDate.text!)\nAddress: \(streetAddress.text!) \(city.text!)\(city.text == "" && state.text == "" ? "" : ",") \(state.text!) \(zip.text!)\nYear: \(year == nil ? "" : year!)\nMajor: \(major == nil ? "" : major!)\nBrother Status:\(brotherStatus == nil ? "" : brotherStatus!)\nPin Number: \(pinNum == nil ? "" : pinNum!)\nProbo Level: \(proboLevel == nil ? "" : proboLevel!)\nHousePositions: \(housePositions == nil ? "" : housePositions!)"
            
            var signUpConfirmed: Bool = false
            
            func handler (alert: UIAlertAction!) {
                signUpConfirmed = true
            }
            
            let alertController = UIAlertController(title: "Confirm Details", message: userInfoString, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: handler)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion:  nil)
            
            if(signUpConfirmed){
            //sign up the user
            self.pool?.signUp(userNameValue, password: passwordValue, userAttributes: attributes, validationData: nil).continueWith {[weak self] (task) -> Any? in
                guard let strongSelf = self else { return nil }
                DispatchQueue.main.async(execute: {
                    if let error = task.error as NSError? {
                        let alertController = UIAlertController(title: error.userInfo["__type"] as? String,
                                                                message: error.userInfo["message"] as? String,
                                                                preferredStyle: .alert)
                        let retryAction = UIAlertAction(title: "Retry", style: .default, handler: nil)
                        alertController.addAction(retryAction)
                        
                        self?.present(alertController, animated: true, completion:  nil)
                    } else if let result = task.result  {
                        // handle the case where user has to confirm his identity via email / SMS
                        if (result.user.confirmedStatus != AWSCognitoIdentityUserStatus.confirmed) {
                            strongSelf.sentTo = result.codeDeliveryDetails?.destination
                            strongSelf.performSegue(withIdentifier: "confirmSignUpSegue", sender:sender)
                        } else {
                            let _ = strongSelf.navigationController?.popToRootViewController(animated: true)
                        }
                    }
                    
                })
                return nil
            }
            }
        }
    }
    
    // MARK: Picture Selection
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    /* * * * * * * * * * * From TOCropViewController Example * * * * * * * * * * */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        
        let cropController = CropViewController(croppingStyle: croppingStyle, image: image)
        cropController.delegate = self
        
        cropController.aspectRatioPreset = .presetSquare; //Set the initial aspect ratio as a square
        cropController.aspectRatioLockEnabled = true // The crop box is locked to the aspect ratio and can't be resized aw
        
        cropController.toolbarPosition = .top
        
        // Set photoImageView to display the selected image.
        
        self.image = image
        
        
        //If profile picture, push onto the same navigation stack
        if croppingStyle == .circular {
            picker.pushViewController(cropController, animated: true)
        }
        else { //otherwise dismiss, and then present from the main controller
            picker.dismiss(animated: true, completion: {
                self.present(cropController, animated: true, completion: nil)
            })
        }
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
        userImage.image = image
        print("image updated #1")
        
        
        
    }
    
    public func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        self.croppedRect = cropRect
        self.croppedAngle = angle
        updateImageViewWithImage(image, fromCropViewController: cropViewController)
        userImage.image = image
        print("image updated #2")
    }
    
    public func updateImageViewWithImage(_ image: UIImage, fromCropViewController cropViewController: CropViewController) {
        imageView.image = image
        layoutImageView()
        
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        
        if cropViewController.croppingStyle != .circular {
            imageView.isHidden = true
            
            cropViewController.dismissAnimatedFrom(self, withCroppedImage: image,
                                                   toView: imageView,
                                                   toFrame: CGRect.zero,
                                                   setup: { self.layoutImageView() },
                                                   completion: { self.imageView.isHidden = false })
        }
        else {
            self.imageView.isHidden = false
            cropViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    public func layoutImageView() {
        guard imageView.image != nil else { return }
        
        let padding: CGFloat = 20.0
        
        var viewFrame = self.view.bounds
        viewFrame.size.width -= (padding * 2.0)
        viewFrame.size.height -= ((padding * 2.0))
        
        var imageFrame = CGRect.zero
        imageFrame.size = imageView.image!.size;
        
        if imageView.image!.size.width > viewFrame.size.width || imageView.image!.size.height > viewFrame.size.height {
            let scale = min(viewFrame.size.width / imageFrame.size.width, viewFrame.size.height / imageFrame.size.height)
            imageFrame.size.width *= scale
            imageFrame.size.height *= scale
            imageFrame.origin.x = (self.view.bounds.size.width - imageFrame.size.width) * 0.5
            imageFrame.origin.y = (self.view.bounds.size.height - imageFrame.size.height) * 0.5
            imageView.frame = imageFrame
        }
        else {
            self.imageView.frame = imageFrame;
            self.imageView.center = CGPoint(x: self.view.bounds.midX, y: self.view.bounds.midY)
        }
    }
    /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
    
    @IBAction func gestureRecognition(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        resignAllKeyboads()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
}
