//
//  EditAvailibilityVC.swift
//  SOSIMPLE
//
//  Created by think360 on 14/07/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class EditAvailibilityVC: UIViewController,WWCalendarTimeSelectorProtocol,UITextFieldDelegate,kDropDownListViewDelegate {
    
    var Dropobj = DropDownListView()
    var dropDownView = UIView()
    
    var selectedStr = NSString()
    var countryListAry = NSArray()
    var countryIDlistAry = NSArray()
    var countryIDstr = NSString()
    var stateListAry = NSArray()
    var stateIDlistAry = NSArray()
    var stateIDstr = NSString()
    var cityListAry = NSArray()
    var cityIDlistAry = NSArray()
    var cityIDstr = NSString()
    var zoneListAry = NSArray()
    var zoneIDstr = NSString()
    var dateUnixStr = String()
    var fromTMUnixStr = String()
    var toTMUnixStr = String()
    
    fileprivate var singleDate: Date = Date()
    fileprivate var multipleDates: [Date] = []
    
    @IBOutlet weak var dateTF: UITextField!
    @IBOutlet weak var fromTimeTF: UITextField!
    @IBOutlet weak var toTimeTF: UITextField!
    @IBOutlet weak var cityTF: UITextField!
    @IBOutlet weak var countryTF: UITextField!
    @IBOutlet weak var stateTF: UITextField!
    @IBOutlet weak var zoneTF: UITextField!
    
    
    let timeView = UIView()
    let alertView = UIView()
    let datePicker = UIDatePicker()
    var selecttimeStr = String()
    let cancelButton = UIButton()
    let doneButton = UIButton()
    var intValue = Int()
    let curntDate = NSDate()
    
    var dataDic = NSDictionary()
    var availibiltyID = String()
    
    
    var  driverID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.tabBar.isHidden = true
        
        if UserDefaults.standard.value(forKey: "driverID") != nil
        {
            driverID = UserDefaults.standard.value(forKey: "driverID") as! String
        }
        intValue = 0
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm aa"
        selecttimeStr = formatter.string(from: curntDate as Date)
        
        zoneListAry=["East Zone","West Zone","North Zone","South Zone"]
        
        print(dataDic)
        dateTF.text! = dataDic.object(forKey: "start_date") as! String
        fromTimeTF.text! = dataDic.object(forKey: "from_time") as! String
        toTimeTF.text! = dataDic.object(forKey: "to_time") as! String
        countryTF.text! = dataDic.object(forKey: "country_name") as! String
        stateTF.text! = dataDic.object(forKey: "state_name") as! String
        cityTF.text! = dataDic.object(forKey: "city_name") as! String
        zoneTF.text! = dataDic.object(forKey: "zone") as! String
        
        countryIDstr = dataDic.object(forKey: "country_id") as! NSString
        stateIDstr = dataDic.object(forKey: "state_id") as! NSString
        cityIDstr = dataDic.object(forKey: "city_id") as! NSString
        zoneIDstr = dataDic.object(forKey: "zone") as! NSString
        availibiltyID = dataDic.object(forKey: "availability_id") as! String
    }

    
    // MARK: Calendar Delegates:
    @IBAction func selectDateBtuuonAction(_ sender: Any) {
            self.openCalendarMethod()
    }
    func openCalendarMethod()
    {
        let selector = WWCalendarTimeSelector.instantiate()
        selector.delegate = self
        self.present(selector, animated: true, completion: nil)
        selector.optionCurrentDate = singleDate
        //selector.optionCurrentDates = Set(multipleDates)
        selector.optionCurrentDateRange.setStartDate(multipleDates.first ?? singleDate)
        selector.optionCurrentDateRange.setEndDate(multipleDates.last ?? singleDate)
        selector.optionStyles.showDateMonth(true)
        selector.optionStyles.showMonth(false)
        selector.optionStyles.showYear(true)
        selector.optionStyles.showTime(false)
    }
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        singleDate = date
        
        let compare:NSInteger = datesComparison(fromDate: Date(), toDate: date)
        if compare == 2 || compare == 3 {
            
            let dateFormat = date.stringFromFormat("yyyy/MM/dd")
            self.dateTF.text! = dateFormat
        }else
        {
            AFWrapperClass.alert("Alert!", message: "Please Select current Date or future Dates only", view: self)
        }
    }
    
    func datesComparison(fromDate:Date,toDate:Date) -> NSInteger {
        if fromDate.trimTime().compare(toDate.trimTime()) == ComparisonResult.orderedDescending
        {
            // NSLog("date1 after date2");
            return 1
        } else if fromDate.trimTime().compare(toDate.trimTime()) == ComparisonResult.orderedAscending
        {
            //NSLog("date1 before date2");
            return 2
        } else
        {
            // NSLog("dates are equal");
            return 3
        }
    }

    // MARK: Time Selection Methods:
    @IBAction func selectFromTimeBtnAction(_ sender: Any) {
        intValue = 1
        self.openTimePickerMethod()
    }
    
    @IBAction func selectTOtimeBtnAction(_ sender: Any) {
        intValue = 2
        self.openTimePickerMethod()
    }
    
    func openTimePickerMethod()
    {
        timeView.isHidden = false
        
        timeView.frame = CGRect(x:0 , y:0 , width: self.view.frame.size.width, height:self.view.frame.size.height)
        timeView.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.5)
        self.view.addSubview(timeView)
        timeView.tag = 1
        
        alertView.frame = CGRect(x:self.view.frame.size.width/2-120 , y:self.view.frame.size.height/2-110 , width:240, height:220)
        alertView.layer.cornerRadius = 5
        alertView.backgroundColor = #colorLiteral(red: 0.8797344565, green: 0.111187242, blue: 0.1556571126, alpha: 1)
        timeView.addSubview(alertView)
        
        cancelButton.frame = CGRect(x:10, y:5, width:70, height:30)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel!.font =  UIFont(name:"Helvetica-Bold", size: 12)
        cancelButton.backgroundColor=#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cancelButton.setTitleColor(UIColor.darkGray, for: .normal)
        cancelButton.addTarget(self, action: #selector(EditAvailibilityVC.cancelButtonAction(_:)), for: UIControlEvents.touchUpInside)
        cancelButton.layer.cornerRadius = 5
        alertView.addSubview(cancelButton)
        
        doneButton.frame = CGRect(x:alertView.frame.size.width-80, y:5, width:70, height:30)
        doneButton.setTitle("Done", for: .normal)
        doneButton.titleLabel!.font = UIFont(name:"Helvetica-Bold",size: 12)
        doneButton.backgroundColor=#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        doneButton.setTitleColor(UIColor.darkGray, for: .normal)
        doneButton.addTarget(self, action: #selector(EditAvailibilityVC.doneButtonAction(_:)), for: UIControlEvents.touchUpInside)
        doneButton.layer.cornerRadius = 5
        alertView.addSubview(doneButton)
        
        let lineLbl = UILabel()
        lineLbl.frame = CGRect(x:0 , y:40 , width: alertView.frame.size.width, height:1)
        lineLbl.backgroundColor=#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        alertView.addSubview(lineLbl)
        
        datePicker.frame = CGRect(x:0 , y:lineLbl.frame.origin.y+2, width:alertView.frame.size.width, height:180)
        datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = UIDatePickerMode.time
        //datePicker.layer.cornerRadius = 5
        datePicker.clipsToBounds = true
        datePicker.addTarget(self, action: #selector(EditAvailibilityVC.startTimeDateChanged), for: .valueChanged)
        alertView.addSubview(datePicker)
    }
    
    func startTimeDateChanged(sender: UIDatePicker) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateFormat = "hh:mm aa"
        selecttimeStr = formatter.string(from: sender.date)        
    }
    
    func cancelButtonAction(_ sender: UIButton!) {
        
        timeView.isHidden = true
        timeView.removeFromSuperview()
        
    }
    func doneButtonAction(_ sender: UIButton!) {
        
        if intValue == 1 {
            fromTimeTF.text = selecttimeStr
        }else if intValue == 2
        {
            toTimeTF.text = selecttimeStr
        }
        
        timeView.isHidden = true
        timeView.removeFromSuperview()
        intValue = 0
    }
    
    // MARK: Country Selection Methods:
    @IBAction func countryButtonAction(_ sender: Any) {
        selectedStr = "Country"
        self.getCountriesMethod()
    }
    
    func getCountriesMethod() -> Void
    {
        let baseURL  = String(format: "%@getcountry",Constants.mainURL)
        let params = ""
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    self.countryListAry = ((responceDic.object(forKey: "data") as! NSDictionary).value(forKey: "country") as! NSArray).value(forKey: "country_name") as! NSArray
                    self.countryIDlistAry = ((responceDic.object(forKey: "data") as! NSDictionary).value(forKey: "country") as! NSArray).value(forKey: "id") as! NSArray
                    //print(self.countryIDlistAry)
                    
                    self.showPopUp(withTitle: "Select Country", withOption: self.countryListAry as! [Any], xy: CGPoint(x:self.view.frame.size.width/2-140 ,y: self.view.frame.size.height/2-200), size: CGSize(width: 280 , height: 400), isMultiple: false)
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

    // MARK:  State Selection Methods:
    @IBAction func stateButtonAction(_ sender: Any) {
        if self.countryTF.text?.characters.count == 0 {
            AFWrapperClass.alert(Constants.applicationName, message: "Please select country", view: self)
        }
        else{
            self.getStatesMethod()
        }
    }
    func getStatesMethod() -> Void
    {
        let baseURL  = String(format: "%@getState",Constants.mainURL)
        let params = "country_id=\(countryIDstr)&state_id=\("")"
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    //print(responceDic)
                    
                    self.stateListAry = ((responceDic.object(forKey: "data") as! NSDictionary).value(forKey: "state") as! NSArray).value(forKey: "name") as! NSArray
                    self.stateIDlistAry = ((responceDic.object(forKey: "data") as! NSDictionary).value(forKey: "state") as! NSArray).value(forKey: "id") as! NSArray
                    
                    self.selectedStr = "Satate"
                    self.showPopUp(withTitle: "Select State", withOption: self.stateListAry as! [Any], xy: CGPoint(x:self.view.frame.size.width/2-140 ,y: self.view.frame.size.height/2-200), size: CGSize(width: 280 , height: 400), isMultiple: false)
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
// MARK: City Selection Methods:
    @IBAction func cityButtonAction(_ sender: Any) {
        if self.stateTF.text?.characters.count == 0 {
            AFWrapperClass.alert(Constants.applicationName, message: "Please select state", view: self)
        }
        else{
            self.getCityMethod()
        }
    }
    func getCityMethod() -> Void
    {
        let baseURL  = String(format: "%@getState",Constants.mainURL)
        let params = "country_id=\("")&state_id=\(stateIDstr)"
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    //print(responceDic)
                    self.cityListAry = ((responceDic.object(forKey: "data") as! NSDictionary).value(forKey: "city") as! NSArray).value(forKey: "name") as! NSArray
                    self.cityIDlistAry = ((responceDic.object(forKey: "data") as! NSDictionary).value(forKey: "city") as! NSArray).value(forKey: "id") as! NSArray
                    
                    self.selectedStr = "City"
                    self.showPopUp(withTitle: "Select City", withOption: self.cityListAry as! [Any], xy: CGPoint(x:self.view.frame.size.width/2-140 ,y: self.view.frame.size.height/2-200), size: CGSize(width: 280 , height: 400), isMultiple: false)
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
   
    @IBAction func zoneButtonAction(_ sender: Any) {
        selectedStr = "Zone"
        self.showPopUp(withTitle: "Select Zone", withOption: self.zoneListAry as! [Any], xy: CGPoint(x:self.view.frame.size.width/2-140 ,y: self.view.frame.size.height/2-125), size: CGSize(width: 280 , height: 250), isMultiple: false)
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
    
    func dropDownListView(_ dropdownListView: DropDownListView!, didSelectedIndex anIndex: Int) {
        if selectedStr == "Country"
        {
            self.countryTF.text! = countryListAry.object(at: anIndex) as! String
            self.countryIDstr = countryIDlistAry.object(at: anIndex) as! NSString
            // print(countryIDstr)
            
            dropDownView.tag = 0
            dropDownView.isHidden = true
            dropDownView.removeFromSuperview()
            self.stateTF.text = ""
            self.cityTF.text = ""
            self.stateIDstr = ""
            self.cityIDstr = ""
        }
        else if selectedStr == "Satate"
        {
            self.stateTF.text! = stateListAry.object(at: anIndex) as! String
            self.stateIDstr = stateIDlistAry.object(at: anIndex) as! NSString
          //  print(stateIDstr)
            dropDownView.tag = 0
            dropDownView.isHidden = true
            dropDownView.removeFromSuperview()
            self.cityTF.text = ""
            self.cityIDstr = ""
        }
        else if selectedStr == "City"
        {
            self.cityTF.text! = cityListAry.object(at: anIndex) as! String
            self.cityIDstr = cityIDlistAry.object(at: anIndex) as! NSString
            dropDownView.tag = 0
            dropDownView.isHidden = true
            dropDownView.removeFromSuperview()
        }
        else if selectedStr == "Zone"
        {
            self.zoneTF.text! = zoneListAry.object(at: anIndex) as! String
            self.zoneIDstr = zoneListAry.object(at: anIndex) as! NSString
            dropDownView.tag = 0
            dropDownView.isHidden = true
            dropDownView.removeFromSuperview()
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // let touch: UITouch? = touches.first
        if (dropDownView.tag == 1) {
            Dropobj.fadeOut()
            dropDownView.tag = 0
            dropDownView.isHidden = true
            dropDownView.removeFromSuperview()
        }
        if timeView.tag == 1 {
            timeView.isHidden = true
            timeView.removeFromSuperview()
            timeView.tag = 0
        }
    }
    func dropDownListView(_ dropdownListView: DropDownListView!, datalist ArryData: NSMutableArray!) {
        // Multiple Selection
    }
    func dropDownListViewDidCancel() {
        // DpopDown Calcelled
    }

    @IBAction func updateAvailabilityBtnAction(_ sender: Any) {
        
        var message = String()
        if (dateTF.text?.isEmpty)! {
            message = "Please select date."
        }
        else if (fromTimeTF.text?.isEmpty)! {
            message = "Please select from time."
        }
        else if (toTimeTF.text?.isEmpty)! {
            message = "Please select to time."
        }
        else if (countryTF.text?.isEmpty)! {
            message = "Please select country."
        }
        else if (stateTF.text?.isEmpty)! {
            message = "Please select state."
        }
//        else if (cityTF.text?.isEmpty)! {
//            message = "Please select city."
//        }
        else if (zoneTF.text?.isEmpty)! {
            message = "Please select zone."
        }
        if message.characters.count > 1 {
            AFWrapperClass.alert(Constants.applicationName, message: message, view: self)
        }else{
            self.addAvailibilityAPIMethod()
        }
    }
    
    func addAvailibilityAPIMethod() -> Void
    {
        if (cityTF.text?.isEmpty)! {
            cityIDstr = ""
        }
        
        let baseURL  = String(format: "%@availablity_edit",Constants.mainURL)
        let params = "driver_id=\(driverID)&id=\(availibiltyID)&start_date=\(dateTF.text!)&from_time=\(fromTimeTF.text!)&to_time=\(toTimeTF.text!)&country_id=\(countryIDstr)&state_id=\(stateIDstr)&city_id=\(cityIDstr)&zones=\(zoneIDstr)"
        AFWrapperClass.svprogressHudShow(title: "Loading...", view: self)
        AFWrapperClass.requestPOSTURLWithUrlsession(baseURL, params: params, success: { (jsonDic) in
            DispatchQueue.main.async {
                AFWrapperClass.svprogressHudDismiss(view: self)
                let responceDic:NSDictionary = jsonDic as NSDictionary
                if (responceDic.object(forKey: "status") as! Bool) == true
                {
                    print(responceDic)
                    let alertController = UIAlertController(title: "SO SIMPLI", message: "Avalilability successfully updated.", preferredStyle: .alert)
                    
                    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {(alert :UIAlertAction!) in
                        
                        self.tabBarController?.selectedIndex = 0
                       // _ = self.navigationController?.popViewController(animated: true)
                         _ = self.navigationController?.popToRootViewController(animated: true)
                        
                        alertController.dismiss(animated: true, completion: nil)
                    })
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
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
        return true
    }
   
    @IBAction func backBtnAction(_ sender: Any) {
         _ = navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 }
