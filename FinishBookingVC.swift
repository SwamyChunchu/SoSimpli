//
//  FinishBookingVC.swift
//  SOSIMPLE
//
//  Created by think360 on 31/07/17.
//  Copyright © 2017 Think360Solutions. All rights reserved.
//

import UIKit

class FinishBookingVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    
    
    @IBAction func viewScheduleButtonAction(_ sender: Any) {
        
        self.tabBarController?.selectedIndex = 0
        _ = self.navigationController?.popToRootViewController(animated: true)
        
//        let simpliVC = self.storyboard?.instantiateViewController(withIdentifier: "CompletedScheduleVC") as! CompletedScheduleVC
//        self.navigationController?.pushViewController(simpliVC, animated: true)
//    self.revealViewController().revealToggle(animated: true)
      
//  working:
        
//  _ = self.navigationController?.popToRootViewController(animated: true)
//        let simpliVC = self.storyboard?.instantiateViewController(withIdentifier: "CompletedScheduleVC") as! CompletedScheduleVC
//   self.navigationController?.pushViewController(simpliVC, animated: false)
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
