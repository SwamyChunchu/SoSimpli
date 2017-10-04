//
//  ChangeAssignedSchedule.swift
//  SOSIMPLE
//
//  Created by think360 on 14/07/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class ChangeAssignedSchedule: UIViewController,UITextFieldDelegate,UITextViewDelegate,kDropDownListViewDelegate {

    var Dropobj = DropDownListView()
    var dropDownView = UIView()
    
    @IBOutlet weak var scheduleNameTF: UITextField!
    @IBOutlet weak var subjectTF: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var  driverID = String()
    var scheduleNameListAry = NSArray()
    var scheduleIDlistAry = NSArray()
    var scheduleNameID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.value(forKey: "driverID") != nil
        {
            driverID = UserDefaults.standard.value(forKey: "driverID") as! String
        }
        
        self.tabBarController?.tabBar.isHidden = true
        descriptionTextView.text = "Enter your description here.."
        descriptionTextView.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }

    @IBAction func scheduleNameBtnAction(_ sender: Any) {
        self.view.endEditing(true)
        let baseURL  = String(format: "%@pending_schdule",Constants.mainURL)
        let params = "driver_id=\(driverID)"
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    
                    print(responceDic)
                    self.scheduleNameListAry = (responceDic.object(forKey: "data") as! NSArray).value(forKey: "schdule_name") as! NSArray
                    self.scheduleIDlistAry = (responceDic.object(forKey: "data") as! NSArray).value(forKey: "schdule_id") as! NSArray
                    
                    self.showPopUp(withTitle: "Select Schedule Name", withOption: self.self.scheduleNameListAry as! [Any], xy: CGPoint(x:self.view.frame.size.width/2-140 ,y: self.view.frame.size.height/2-140), size: CGSize(width: 280 , height: 250), isMultiple: false)
                }
                else
                {
                AFWrapperClass.alert(Constants.applicationName, message: responceDic.object(forKey: "message") as! String, view: self)
                }
            }
        })
        { (error) in
            AFWrapperClass.svprogressHudDismiss(view: self)
            AFWrapperClass.alert(Constants.applicationName, message: error.localizedDescription, view: self)
        }
    }
    
    //MARK: DropDown Delegates:
    func showPopUp(withTitle popupTitle: String, withOption arrOptions: [Any], xy point: CGPoint, size: CGSize, isMultiple: Bool)
    {
        Dropobj.fadeOut()
        dropDownView.isHidden = false
        dropDownView.frame = CGRect(x:0 , y:0 , width: self.view.frame.size.width, height:self.view.frame.size.height)
        dropDownView.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).withAlphaComponent(0.5)
        self.view.addSubview(dropDownView)
        dropDownView.tag = 1
        Dropobj = DropDownListView(title: popupTitle, options: arrOptions, xy: point, size: size, isMultiple: isMultiple)
        Dropobj.delegate = self
        Dropobj.show(in: dropDownView, animated: true)
        Dropobj.setBackGroundDropDown_R(224.0, g: 29.0, b: 40.0, alpha: 0.90)
    }
 
    func dropDownListView(_ dropdownListView: DropDownListView!, didSelectedIndex anIndex: Int)
    {
        self.scheduleNameTF.text! = self.scheduleNameListAry.object(at: anIndex) as! String
        self.scheduleNameID = scheduleIDlistAry.object(at: anIndex) as! String
        
        dropDownView.tag = 0
        dropDownView.isHidden = true
        dropDownView.removeFromSuperview()
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // let touch: UITouch? = touches.first
        if (dropDownView.tag == 1) {
            Dropobj.fadeOut()
            dropDownView.tag = 0
            dropDownView.isHidden = true
            dropDownView.removeFromSuperview()
        }
    }
    func dropDownListView(_ dropdownListView: DropDownListView!, datalist ArryData: NSMutableArray!) {
        // Multiple Selection
    }
    func dropDownListViewDidCancel() {
        // DpopDown Calcelled
    }
    
    @IBAction func sendRequestBtnAction(_ sender: UIButton) {
        
        var message = String()
        if (scheduleNameTF.text?.isEmpty)!
        {
            message = "Please choose schedule name."
        }
        else if (subjectTF.text?.isEmpty)!
        {
            message = "Please enter subject"
        }
        else if (descriptionTextView.text?.isEmpty)! || descriptionTextView.text == "Enter your description here.."
        {
            message = "Please enter schedule description."
        }
        if message.characters.count > 1 {
        AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }else{
            
            self.contactOperatorAPImethod()
        }
    }
    
    func contactOperatorAPImethod() -> Void
    {
        self.view.endEditing(true)
        
        let baseURL  = String(format: "%@contact_operator",Constants.mainURL)
        let params = "driver_id=\(driverID)&schdule_id=\(self.scheduleNameID)&Subject=\(subjectTF.text!)&message=\(descriptionTextView.text!)"
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    self.scheduleNameTF.text = ""
                    self.subjectTF.text = ""
                    self.descriptionTextView.text = "Enter your description here.."
                    self.descriptionTextView.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                    
                    let imageView = UIImageView(frame: CGRect(x:120, y:5, width:34, height:35))
                    imageView.image = UIImage(named: "Tick30")
                    
                    let alertMessage = UIAlertController(title: "                                                                                ", message: "Your Request has been successfully sent...", preferredStyle: .alert)
                    let image = UIImage(named: "Image")
                    let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                    action.setValue(image, forKey: "image")
                    
                    alertMessage .addAction(action)
                    //alertMessage.view.tintColor = #colorLiteral(red: 0.4285447896, green: 0.747687161, blue: 0.3533237576, alpha: 1)
                    self.present(alertMessage, animated: true, completion: nil)
                    alertMessage.view.addSubview(imageView)
                }
                else
                {
                    AFWrapperClass.alert(Constants.applicationName, message: responceDic.object(forKey: "message") as! String, view: self)
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
        // self.searchTableView.isHidden=true
        return true
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) {
            descriptionTextView.text = nil
            descriptionTextView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = "Enter your description here.."
            descriptionTextView.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }

    @IBAction func backButtonAction(_ sender: Any) {
        _ = navigationController?.popViewController(animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
