//
//  PlacesCVC.swift
//  ProjectTrekkingApp
//
//  Created by Chaparala,Jyothsna on 4/19/23.
//


import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

class PlacesCVC: UICollectionViewCell {
    
    let db = Firestore.firestore()
    
    @IBOutlet weak var titleLBL: UILabel!
    
    @IBOutlet weak var imageIV: UIImageView!
    
}
