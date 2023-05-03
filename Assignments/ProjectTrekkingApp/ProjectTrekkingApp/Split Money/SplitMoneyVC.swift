//
//  SplitMoneyVC.swift
//  ProjectTrekkingApp
//
//  Created by Chaparala,Jyothsna on 4/19/23.
//

import UIKit

class SplitMoneyVC: UIViewController {
    
    @IBOutlet weak var amountTF: UITextField!
    
    @IBOutlet weak var numOfPeopleTF: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func splitBTN(_ sender: UIButton) {
        guard let amount = self.amountTF.text, let money = Double(amount) else {
            self.showAlert(having: "Info⚠️", with: "Please fill in the contents")
            return
        }
        
        guard let people = self.numOfPeopleTF.text, let person = Int(people) else {
            self.showAlert(having: "Info⚠️", with: "Please fill in the contents")
            return
        }
        
        if(person == 1 || person == 0) {
            self.showAlert(having: "Result", with: "No need to split")
        } else {
            self.showAlert(having: "Result", with: String(format: "%.2f", (money/Double(person))) + " per each person")
        }
    }
    
    @IBAction func closeBTN(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    private func showAlert(having title: String, with message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
         })
        dialogMessage.addAction(ok)
        self.present(dialogMessage, animated: true, completion: nil)
    }

}
