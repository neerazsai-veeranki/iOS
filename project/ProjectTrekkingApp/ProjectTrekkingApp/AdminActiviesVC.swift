//
//  AdminActiviesVC.swift
//  ProjectTrekkingApp
//
//  Created by Chaparala,Jyothsna on 5/1/23.
//

import UIKit

class AdminActiviesVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
    @IBAction func viewPlacesBTN(_ sender: UIButton) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "viewPlacesListScreen") as! TrekPlacesListVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func addPlacesBTN(_ sender: UIButton) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "addTrekPlacesScreen") as! AddTrekPlaceVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    @IBAction func viewGuidesBTN(_ sender: UIButton) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "viewGuidesScreen") as! ViewGuidesVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    
    @IBAction func addGuidesBTN(_ sender: UIButton) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "addGuidesScreen") as! AddGuidesVC
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @IBAction func logoutBTN(_ sender: UIButton) {
        let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "chooseUserScreen") as! ChooseUserVC
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
