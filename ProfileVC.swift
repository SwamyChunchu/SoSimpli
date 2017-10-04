//
//  ProfileVC.swift
//  SOSIMPLE
//
//  Created by think360 on 11/07/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit
import Alamofire
import QuartzCore
import CoreLocation
import SDWebImage


class ProfileVC: UIViewController,UIImagePickerControllerDelegate,
UINavigationControllerDelegate,UITextFieldDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var profilrImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var driverTypeLbl: UILabel!
    @IBOutlet weak var nameTF: ACFloatingTextfield!
    @IBOutlet weak var cameraButton: UIButton!
    
    var imagePicker = UIImagePickerController()
    var currentSelectedImage = UIImage()
    var driverID = String()
    var appDel = AppDelegate()
    var frontView = UIView()
    var camString = String()
    
    var changePWpopUpView = UIScrollView()
    var pwAlertView = UIView()
    var currentPWTF = ACFloatingTextfield()
    var changePWTF = ACFloatingTextfield()
    var confirmPWTF = ACFloatingTextfield()
    var cancelPWbtn = UIButton()
    var donePWbtn = UIButton()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       appDel = UIApplication.shared.delegate as! AppDelegate
       if UserDefaults.standard.value(forKey: "driverID") != nil
        {
            driverID = UserDefaults.standard.value(forKey: "driverID") as! String
        }

        frontView.frame = CGRect(x:0, y:64, width:self.view.frame.size.width, height:self.view.frame.size.height)
        frontView.backgroundColor=UIColor(patternImage: UIImage(named: "black_strip1")!)
        frontView.isHidden=true
        if UI_USER_INTERFACE_IDIOM() == .pad {
            frontView.frame = CGRect(x:0, y:80, width:self.view.frame.size.width, height:self.view.frame.size.height)
        }
        self.view.addSubview(frontView)
        if revealViewController() != nil {
            revealViewController().rearViewRevealWidth = 260
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
             view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        imagePicker.delegate = self
        self.getDriverDetailsAPIMethod()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.revealViewController().delegate=self
        
        frontView.frame = CGRect(x:0, y:64, width:self.view.frame.size.width, height:self.view.frame.size.height)
        frontView.backgroundColor=UIColor(patternImage: UIImage(named: "black_strip1")!)
        if UI_USER_INTERFACE_IDIOM() == .pad {
            frontView.frame = CGRect(x:0, y:80, width:self.view.frame.size.width, height:self.view.frame.size.height)
        }
        frontView.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        frontView.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        frontView.isHidden=true
        self.view.addSubview(frontView)
        self.tabBarController?.tabBar.isHidden = false
        
        if self.camString == "" {
        self.getDriverDetailsAPIMethod()
        }

        self.badgeCountAPIMethod()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        self.changePWpopUpView.removeFromSuperview()
    }
    
    // MARK: -> User Profile Method
    func getDriverDetailsAPIMethod () -> Void
    {
        self.nameTF.text! = " "
        let baseURL: String  = String(format: "%@driver_history/",Constants.mainURL)
        let params = "id=\(driverID)"
        
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                   // print(responceDic)
                    
                    self.appDel.profileDataDic = responceDic.object(forKey: "data") as! NSDictionary
                    
                    let imageURL: String = (responceDic.object(forKey: "data") as! NSDictionary).object(forKey: "driver_image") as! String
                    let url = NSURL(string:imageURL)
                    self.profilrImageView.setShowActivityIndicator(true)
                    self.profilrImageView.setIndicatorStyle(.gray)
                    self.profilrImageView.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "ProfilePlaceHolder"))
                    self.nameTF.text! = (responceDic.object(forKey: "data") as! NSDictionary).object(forKey: "driver_name") as! String
                    self.nameLabel.text! = (responceDic.object(forKey: "data") as! NSDictionary).object(forKey: "driver_name") as! String
                    
                    UserDefaults.standard.set((responceDic.object(forKey: "data") as! NSDictionary).object(forKey: "driver_name") as! String, forKey: "DriverNameSave")
                }
                else
                {
                    AFWrapperClass.svprogressHudDismiss(view: self)
                    AFWrapperClass.alert(Constants.applicationName, message: "No Data Found", view: self)
                }
            }
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }
    
    //MARK:  -> ImagePicker Controller Delegates
    @IBAction func cameraButtonAction(_ sender: Any) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        let pibraryAction = UIAlertAction(title: "From Photo Library", style: .default, handler:
            {(alert: UIAlertAction!) -> Void in
                
                self.camString = "camSelected"
                self.imagePicker.sourceType = .photoLibrary
                self.imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
                self.present(self.imagePicker, animated: true, completion: nil)
        })
        let cameraction = UIAlertAction(title: "Camera", style: .default, handler:
            {(alert: UIAlertAction!) -> Void in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    
                self.camString = "camSelected"
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePicker.cameraCaptureMode = .photo
                self.imagePicker.modalPresentationStyle = .fullScreen
                self.present(self.imagePicker,animated: true,completion: nil)
                } else {
                AFWrapperClass.alert(Constants.applicationName, message: "Sorry, this device has no camera", view: self)
                }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
            {
                (alert: UIAlertAction!) -> Void in
            })
        optionMenu.addAction(pibraryAction)
        optionMenu.addAction(cameraction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            let popOverPresentationController : UIPopoverPresentationController = optionMenu.popoverPresentationController!
            popOverPresentationController.sourceView                = cameraButton
            popOverPresentationController.sourceRect                = cameraButton.bounds
            popOverPresentationController.permittedArrowDirections  = UIPopoverArrowDirection.any
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        currentSelectedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //currentSelectedImage = self.image(withReduce: currentSelectedImage, scaleTo: CGSize(width: CGFloat(40), height: CGFloat(40)))
        self.profilrImageView.image = currentSelectedImage
       self.updateProfileImageAPIMethod()
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
        self.camString = ""
    }
    
    func updateProfileImageAPIMethod () -> Void
    {
        self.view.endEditing(true)
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        
        let imageData: Data? = UIImageJPEGRepresentation(currentSelectedImage, 0.5)
        if imageData == nil {
            let imgData: Data? = UIImageJPEGRepresentation(self.profilrImageView.image!, 0.5)
            self.currentSelectedImage = UIImage(data: imgData! as Data)!
            //currentSelectedImage = UIImage(named: "profilePlaceHolder")!
        }
        let parameters = ["id"              : driverID,
                          "driver_name"     : "",
                          "password"        : ""
                         ] as [String : String]
        
        Alamofire.upload(multipartFormData: {(multipartFormData) in
            
            let image = self.currentSelectedImage
            multipartFormData.append(UIImageJPEGRepresentation(image, 0.5)!, withName: "driver_pic", fileName: "uploadedPic.jpeg", mimeType: "image/jpeg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to:String(format: "%@driveredit/",Constants.mainURL))
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                })
                upload.responseJSON { response in
                if response.result.isSuccess
                {
                   AFWrapperClass.svprogressHudDismiss(view: self)
                   if (response.result.value as! NSDictionary).value(forKey: "status") as! Bool == true
                   {
                    //print(response.result.value as! NSDictionary)
                            
                    self.appDel.profileDataDic = (response.result.value as! NSDictionary).object(forKey: "data") as! NSDictionary
                            
                    let imageURL: String = ((response.result.value as! NSDictionary).object(forKey: "data") as! NSDictionary).object(forKey: "driver_image") as! String
                    let url = NSURL(string:imageURL)
                    self.profilrImageView.setShowActivityIndicator(true)
                    self.profilrImageView.setIndicatorStyle(.gray)
                    self.profilrImageView.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "ProfilePlaceHolder"))
                            
                    AFWrapperClass.alert(Constants.applicationName, message: "Profile Pic Update Successfully", view: self)
                    self.camString = ""
                    
                    }else{
                    AFWrapperClass.alert(Constants.applicationName, message: "Profile Pic not Updated Please try again.", view: self)
                    
                    self.camString = ""
                    }

                    }
                    if response.result.isFailure
                    {
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        let error : NSError = response.result.error! as NSError
                        AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
                        self.camString = ""
                    }
                }
            case .failure(let error):
                AFWrapperClass.svprogressHudDismiss(view: self)
                AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
                
                self.camString = ""
                
                break
            }
        }
    }
  
//MARK:  Update Profile Button Action:
    @IBAction func updateProfileBtnAction(_ sender: Any) {
        
        var message = String()
        if (nameTF.text?.isEmpty)!
        {
            message = "Please enter name"
        }
        
        if message.characters.count > 1 {
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }else{
            self.updateProfileAPIMethod()
        }
    }
    func updateProfileAPIMethod () -> Void
    {
        self.view.endEditing(true)
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        
        let imageData: Data? = UIImageJPEGRepresentation(currentSelectedImage, 0.5)
        if imageData == nil {
            let imgData: Data? = UIImageJPEGRepresentation(self.profilrImageView.image!, 0.5)
            self.currentSelectedImage = UIImage(data: imgData! as Data)!
            //currentSelectedImage = UIImage(named: "profilePlaceHolder")!
        }
        let parameters = ["id"              : driverID,
                          "driver_name"     : nameTF.text!,
                          "password"        : ""
                         ] as [String : String]
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            
            let image = self.currentSelectedImage
            multipartFormData.append(UIImageJPEGRepresentation(image, 0.5)!, withName: "driver_pic", fileName: "uploadedPic.jpeg", mimeType: "image/jpeg")
            for (key, value) in parameters {
                multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key)
            }
        }, to:String(format: "%@driveredit/",Constants.mainURL))
        { (result) in
            switch result {
            case .success(let upload, _, _):
                upload.uploadProgress(closure: { (progress) in
                })
                upload.responseJSON { response in
                    if response.result.isSuccess
                    {
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        if (response.result.value as! NSDictionary).value(forKey: "status") as! Bool == true
                        {
                           // print(response.result.value as! NSDictionary)
                            self.appDel.profileDataDic = (response.result.value as! NSDictionary).object(forKey: "data") as! NSDictionary
                            
                            let imageURL: String = ((response.result.value as! NSDictionary).object(forKey: "data") as! NSDictionary).object(forKey: "driver_image") as! String
                            let url = NSURL(string:imageURL)
                            self.profilrImageView.setShowActivityIndicator(true)
                            self.profilrImageView.setIndicatorStyle(.gray)
                            self.profilrImageView.sd_setImage(with: (url)! as URL, placeholderImage: UIImage.init(named: "ProfilePlaceHolder"))
                            
                            self.nameTF.text! = ((response.result.value as! NSDictionary).object(forKey: "data") as! NSDictionary).object(forKey: "driver_name") as! String
                            self.nameLabel.text! = ((response.result.value as! NSDictionary).object(forKey: "data") as! NSDictionary).object(forKey: "driver_name") as! String
                            
                            UserDefaults.standard.set(((response.result.value as! NSDictionary).object(forKey: "data") as! NSDictionary).object(forKey: "driver_name") as! String, forKey: "DriverNameSave")                            
                            
                            AFWrapperClass.alert(Constants.applicationName, message: "Profile Info Update Successfully", view: self)
                            
                        }else{
                            AFWrapperClass.alert(Constants.applicationName, message: "Profile Info not Updated Please try again", view: self)
                        }
                    }
                    if response.result.isFailure
                    {
                        AFWrapperClass.svprogressHudDismiss(view: self)
                        let error : NSError = response.result.error! as NSError
                        AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
                    }
                }
            case .failure(let error):
                AFWrapperClass.svprogressHudDismiss(view: self)
                AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
                break
            }
        }
    }
    
// MARK: Change PassWord Method:
    @IBAction func changePasswordButtonAction(_ sender: Any) {
        self.changePassWordViewMethod()
    }
    @objc private func changePassWordViewMethod () -> Void
    {
        changePWpopUpView.frame = CGRect(x:0, y:0, width:self.view.frame.size.width, height:self.view.frame.size.height)
        changePWpopUpView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.view .addSubview(changePWpopUpView)
        changePWpopUpView.contentSize = CGSize(width:self.view.frame.size.width , height: self.view.frame.size.height)
        
        pwAlertView.frame = CGRect(x:30, y:self.view.frame.size.height/2-170, width:self.view.frame.size.width-60, height:300)
        pwAlertView.backgroundColor = UIColor.white
        pwAlertView.layer.cornerRadius = 5
        changePWpopUpView.addSubview(pwAlertView)
        
        let numberLbl = UILabel()
        numberLbl.frame = CGRect(x:0, y:0, width:pwAlertView.frame.size.width, height:50)
        numberLbl.backgroundColor = #colorLiteral(red: 0.8797463775, green: 0.1150355414, blue: 0.1554988027, alpha: 1)
        numberLbl.layer.cornerRadius = 5
        numberLbl.text = "CHANGE PASSWORD"
        numberLbl.font =  UIFont(name:"Helvetica-Bold", size: 16)
        numberLbl.textAlignment = .center
        numberLbl.textColor = UIColor.white
        pwAlertView.addSubview(numberLbl)
        
        currentPWTF.frame = CGRect(x:10, y:60, width:pwAlertView.frame.size.width-20, height:46)
        currentPWTF.delegate = self
        currentPWTF.placeholder = "Current Password"
        currentPWTF.font = UIFont(name: "Helvetica", size: 16)
        currentPWTF.placeHolderColor=UIColor.darkGray
        currentPWTF.selectedPlaceHolderColor=#colorLiteral(red: 0.8797463775, green: 0.1150355414, blue: 0.1554988027, alpha: 1)
        currentPWTF.lineColor=UIColor.clear
        currentPWTF.selectedLineColor=UIColor.clear
        currentPWTF.isSecureTextEntry = true
        currentPWTF.autocorrectionType = UITextAutocorrectionType.no
        pwAlertView.addSubview(currentPWTF)
        
        let curntLineLbl = UILabel()
        curntLineLbl.frame = CGRect(x:10, y:currentPWTF.frame.origin.y+46, width:pwAlertView.frame.size.width-20, height:1)
        curntLineLbl.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        pwAlertView.addSubview(curntLineLbl)
        
        changePWTF.frame = CGRect(x:10, y:currentPWTF.frame.origin.y+56, width:pwAlertView.frame.size.width-20, height:46)
        changePWTF.delegate = self
        changePWTF.placeholder = "New Password"
        changePWTF.font = UIFont(name: "Helvetica", size: 16)
        changePWTF.placeHolderColor=UIColor.darkGray
        changePWTF.selectedPlaceHolderColor=#colorLiteral(red: 0.8797463775, green: 0.1150355414, blue: 0.1554988027, alpha: 1)
        changePWTF.lineColor=UIColor.clear
        changePWTF.selectedLineColor=UIColor.clear
        changePWTF.isSecureTextEntry = true
        changePWTF.autocorrectionType = UITextAutocorrectionType.no
        pwAlertView.addSubview(changePWTF)
        
        let pwLineLbl = UILabel()
        pwLineLbl.frame = CGRect(x:10, y:changePWTF.frame.origin.y+46, width:pwAlertView.frame.size.width-20, height:1)
        pwLineLbl.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        pwAlertView.addSubview(pwLineLbl)
        
        confirmPWTF.frame = CGRect(x:10, y:changePWTF.frame.origin.y+56, width:pwAlertView.frame.size.width-20, height:46)
        confirmPWTF.delegate = self
        confirmPWTF.placeholder = "Confirm New Password"
        confirmPWTF.font = UIFont(name: "Helvetica", size: 16)
        confirmPWTF.placeHolderColor=UIColor.darkGray
        confirmPWTF.selectedPlaceHolderColor=#colorLiteral(red: 0.8797463775, green: 0.1150355414, blue: 0.1554988027, alpha: 1)
        confirmPWTF.lineColor=UIColor.clear
        confirmPWTF.selectedLineColor=UIColor.clear
        confirmPWTF.isSecureTextEntry = true
        confirmPWTF.autocorrectionType = UITextAutocorrectionType.no
        pwAlertView.addSubview(confirmPWTF)
        
        let confimLineLbl = UILabel()
        confimLineLbl.frame = CGRect(x:10, y:confirmPWTF.frame.origin.y+46, width:pwAlertView.frame.size.width-20, height:1)
        confimLineLbl.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        pwAlertView.addSubview(confimLineLbl)
        
        cancelPWbtn.frame = CGRect(x:pwAlertView.frame.size.width/2-125, y:confirmPWTF.frame.origin.y+66, width:120, height:40)
        cancelPWbtn.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cancelPWbtn.setTitle("CANCEL", for: .normal)
        cancelPWbtn.setTitleColor(UIColor.darkGray, for: .normal)
        cancelPWbtn.addTarget(self, action: #selector(ProfileVC.cancelPasswordButtonAction(_:)), for: UIControlEvents.touchUpInside)
        cancelPWbtn.layer.cornerRadius = 2
        pwAlertView.addSubview(cancelPWbtn)
        
        
        donePWbtn.frame = CGRect(x:pwAlertView.frame.size.width/2+5, y:confirmPWTF.frame.origin.y+66, width:120, height:40)
        donePWbtn.titleLabel!.font =  UIFont(name:"Helvetica-Bold", size: 16)
        //registerButton.setTitleColor(UIColor.white, for: .normal)
        donePWbtn.backgroundColor=#colorLiteral(red: 0.8797463775, green: 0.1150355414, blue: 0.1554988027, alpha: 1)
        donePWbtn.setTitle("CHANGE", for: .normal)
        donePWbtn.addTarget(self, action: #selector(ProfileVC.donePasswordButtonAction(_:)), for: UIControlEvents.touchUpInside)
        donePWbtn.layer.cornerRadius = 2
        pwAlertView.addSubview(donePWbtn)
        
    }
    func cancelPasswordButtonAction(_ sender : UIButton)
    {
        self.view.endEditing(true)
        currentPWTF.text = ""
        changePWTF.text = ""
        confirmPWTF.text = ""
        changePWpopUpView.removeFromSuperview()
    }
    func donePasswordButtonAction(_ sender : UIButton)
    {
        
        var message = String()
        if (currentPWTF.text?.isEmpty)!
        {
            message = "Please enter current password"
        }
        else if (changePWTF.text?.characters.count)! < 6
        {
            message = "Password sould be minimum 6 characters"
        }
        else if !(changePWTF.text == confirmPWTF.text)
        {
            message = "Confirm password doesn't match please try again"
        }
        if message.characters.count > 1 {
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }else{
            self.passwordChangeAPImethod()
        }
    }
    
    func passwordChangeAPImethod () -> Void
    {
        self.view.endEditing(true)
        let baseURL: String  = String(format: "%@change_password",Constants.mainURL)
        let params = "driver_id=\(driverID)&current_password=\(currentPWTF.text!)&new_password=\(changePWTF.text!)"
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    self.currentPWTF.text = ""
                    self.changePWTF.text = ""
                    self.confirmPWTF.text = ""
                    self.changePWpopUpView.removeFromSuperview()
                    AFWrapperClass.alert(Constants.applicationName, message:"Your password successfully updated.", view: self)
                }
                else
                {
                    AFWrapperClass.alert(Constants.applicationName, message:"Current password does not matched Please try again.", view: self)
                }
            }
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }
    
// MARK: TextField Dekegate Methods:
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    let ACCEPTABLE_CHARACTERS = " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz."
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let cs = CharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
        let filtered: String = (string.components(separatedBy: cs) as NSArray).componentsJoined(by: "")
        if textField == nameTF{
            
            return (string == filtered)

        } else{
            return true
        }
    }
    
    //MARK: Notification Count:
    func badgeCountAPIMethod () -> Void
    {
        let baseURL  = String(format: "%@sos_count",Constants.mainURL)
        let params = "driver_id=\(driverID)"
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    //print(responceDic)
                    let countStr:String = (responceDic.object(forKey:"data") as! NSDictionary).object(forKey:"count") as! String
                    if countStr == "0"
                    {
                        self.tabBarController?.tabBar.items?[2].badgeValue = nil
                    }else{
                        self.tabBarController?.tabBar.items?[2].badgeValue = countStr
                    }
                }
                else
                {
                AFWrapperClass.svprogressHudDismiss(view: self)
                // AFWrapperClass.alert(Constants.applicationName, message: responceDic.object(forKey: "message") as! String, view: self)
                }
            }
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
extension ProfileVC: SWRevealViewControllerDelegate
{
    func revealController(_ revealController: SWRevealViewController, willMoveTo position: FrontViewPosition) {
        if position == FrontViewPositionLeft {
            //  self.view.addSubview(frontView)
            self.view.isUserInteractionEnabled = true
            frontView.isHidden=true
            self.tabBarController?.tabBar.isUserInteractionEnabled = true
            self.view.endEditing(true)

        }
        else {
            self.view.isUserInteractionEnabled = true
            frontView.isHidden=false
            self.tabBarController?.tabBar.isUserInteractionEnabled = false
            self.view.endEditing(true)

        }
    }
    func revealController(_ revealController: SWRevealViewController, didMoveTo position: FrontViewPosition) {
        if position == FrontViewPositionLeft {
            //  self.view.addSubview(frontView)
            self.view.isUserInteractionEnabled = true
            frontView.isHidden=true
            self.tabBarController?.tabBar.isUserInteractionEnabled = true
            self.view.endEditing(true)

        }
        else {
            self.view.isUserInteractionEnabled = true
            frontView.isHidden=false
            self.tabBarController?.tabBar.isUserInteractionEnabled = false
            self.view.endEditing(true)

        }
    }
}
