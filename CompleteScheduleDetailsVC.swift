//
//  CompleteScheduleDetailsVC.swift
//  SOSIMPLE
//
//  Created by think360 on 14/07/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class CompleteScheduleDetailsVC: UIViewController {

    var dataDic = NSDictionary()
    
    @IBOutlet weak var zoneNameheaderLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var zoneCityLbl: UILabel!
    @IBOutlet weak var schedileInfLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dateLbl.text! = dataDic.object(forKey: "schdule_date") as! String
        timeLbl.text! = String(format:"%@ - %@",dataDic.object(forKey: "TimeFrom") as! String,dataDic.object(forKey: "TimeTo") as! String)
        schedileInfLbl.text! = dataDic.object(forKey: "schdule_info") as! String
        
        let sosZoneID: String = dataDic.object(forKey: "schdule_zone") as! String
        var sosZoneStr = String()
        if sosZoneID == "1"
        {
            sosZoneStr = "EAST ZONE"
        }else if sosZoneID == "2"
        {
            sosZoneStr = "WEST ZONE"
        }else if sosZoneID == "3"
        {
            sosZoneStr = "NORTH ZONE"
        }else if sosZoneID == "4"
        {
            sosZoneStr = "SOUTH ZONE"
        }
        zoneNameheaderLbl.text! = sosZoneStr
        
        
        let sosZoneIDtwo: String = dataDic.object(forKey: "schdule_zone") as! String
        var sosZoneStrTwo = String()
        if sosZoneIDtwo == "1"
        {
            sosZoneStrTwo = "East Zone"
        }else if sosZoneIDtwo == "2"
        {
            sosZoneStrTwo = "West Zone"
        }else if sosZoneIDtwo == "3"
        {
            sosZoneStrTwo = "North Zone"
        }else if sosZoneIDtwo == "4"
        {
            sosZoneStrTwo = "South Zone"
        }

        zoneCityLbl.text! = String(format:"%@, %@",sosZoneStrTwo ,dataDic.object(forKey: "city") as! String)
    }
 
    @IBAction func backButtonAction(_ sender: Any) {
        
       _ = navigationController?.popViewController(animated: true) 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
