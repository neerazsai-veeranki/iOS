//
//  ChooseUserVC.swift
//  ProjectTrekkingApp
//
//  Created by Chaparala,Jyothsna on 4/28/23.
//

import UIKit

class ChooseUserVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    
    @IBAction func adminBTN(_ sender: UIButton) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "adminLoginScreen") as! AdminLoginVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    @IBAction func userBTN(_ sender: UIButton) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "userLoginScreen") as! LoginVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
