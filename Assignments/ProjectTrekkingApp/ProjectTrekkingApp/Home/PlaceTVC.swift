//
//  PlaceTVC.swift
//  ProjectTrekkingApp
//
//  Created by Chaparala,Jyothsna on 5/2/23.
//

import UIKit

class PlaceTVC: UITableViewCell {

    @IBOutlet weak var placeImage: UIImageView!
    
    @IBOutlet weak var placeName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
