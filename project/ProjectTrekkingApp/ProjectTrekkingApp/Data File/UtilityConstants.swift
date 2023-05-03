//
//  UtilityConstants.swift
//  ProjectTrekkingApp
//
//  Created by Chaparala,Jyothsna on 4/19/23.
//

import Foundation
import FirebaseCore
import FirebaseFirestore

struct UserProfile {
    var firstName: String?
    var lastName: String?
    var email: String?
    var mobile: String?
    var gender: String?
    var dateOfBirth: String?
    var savedPlaces: [String]?
}

struct TrekPlaces {
    var image: [String]?
    var title: String?
    var distance: Double?
    var effortLevel: String?
    var description: String?
    var trailStartLocation: [String]?
    var trailEndLocation: [String]?
}

let trekPlaces = [
    TrekPlaces(image: ["lauterbrunnenValley_1", "lauterbrunnenValley_2", "lauterbrunnenValley_3", "lauterbrunnenValley_4", "lauterbrunnenValley_5"], title: "Lauterbrunnen Valley", distance: 2.5, effortLevel: "Beginner", description: "The Lauterbrunnen Valley is a beautiful valley located in the heart of the Bernese Oberland region of Switzerland that features a 2.5-mile roundtrip trail that is perfect for beginners. The trail takes you through the heart of the valley and offers stunning views of the surrounding mountains, including the famous Eiger, Mönch, and Jung", trailStartLocation: ["46.5981", "7.9119"], trailEndLocation: ["46.5976", "7.9046"]),
    TrekPlaces(image: ["runyonCanyonPark_1", "runyonCanyonPark_2", "runyonCanyonPark_3", "runyonCanyonPark_4", "runyonCanyonPark_5"], title: "Runyon Canyon Park", distance: 3.3, effortLevel: "Beginner", description: "Runyon Canyon Park is a beautiful urban park located in the heart of Los Angeles that features a 3.3-mile loop trail that is perfect for beginners. The trail offers stunning views of the city and is known for its easy terrain, making it a popular spot for hikers of all skill levels. Runyon Canyon Park is also known for its diverse plant and wildlife, making it a great place to connect with nature in the heart of the city.", trailStartLocation: ["34.1141", "118.3526"], trailEndLocation: ["34.1148", "118.3527"]),
    TrekPlaces(image: ["johnstonCanyon_1", "johnstonCanyon_2", "johnstonCanyon_3", "johnstonCanyon_4", "johnstonCanyon_5"], title: "Johnston Canyon", distance: 3.1, effortLevel: "Beginner", description: "Johnston Canyon is a beautiful canyon located in Banff National Park, Canada, that features a 3.1-mile roundtrip trail that is perfect for beginners. The trail takes you through the heart of the canyon and offers stunning views of waterfalls, crystal clear streams, and the surrounding mountains. Johnston Canyon is also home to a variety of different wildlife, including black bears, making it a great place to connect with nature.", trailStartLocation: ["51.2468", "115.8387"], trailEndLocation: ["51.2475", "115.8420"]),
    TrekPlaces(image: ["mendenhallGlacier_1", "mendenhallGlacier_2", "mendenhallGlacier_3", "mendenhallGlacier_4", "mendenhallGlacier_5"], title: "Mendenhall Glacier", distance: 4.4, effortLevel: "Beginner", description: "The Mendenhall Glacier is a beautiful glacier located just outside of Juneau, Alaska, that features a 4.4-mile roundtrip trail that is perfect for beginners. The trail takes you to the base of the glacier and offers stunning views of the surrounding landscape, including snow-capped mountains and crystal clear streams. The Mendenhall Glacier is also home to a variety of different wildlife, including bald eagles and brown bears, making it a great place to connect with nature.", trailStartLocation: ["58.4241", "134.5638"], trailEndLocation: ["58.4323", "134.5683"]),
    TrekPlaces(image: ["eppingForest_1", "eppingForest_2", "eppingForest_3", "eppingForest_4", "eppingForest_5"], title: "Epping Forest", distance: 4, effortLevel: "Beginner", description: "Epping Forest is a beautiful ancient woodland that is located just outside of London and features a 4-mile loop trail that is perfect for beginners. The trail takes you through a variety of different landscapes, including open fields, dense forests, and serene ponds, and is known for its easy terrain. Epping Forest is also home to a variety of different wildlife, including deer, foxes, and badgers, making it a great place to connect with nature.", trailStartLocation: ["51.6337", "0.0239"], trailEndLocation: ["51.6332", "0.0173"]),
    TrekPlaces(image: ["tooheyForest_1", "tooheyForest_2", "tooheyForest_3", "tooheyForest_4", "tooheyForest_5"], title: "Toohey Forest", distance: 1.9, effortLevel: "Beginner", description: "Toohey Forest is a beautiful forest reserve located in Brisbane, Australia, that features a variety of different hiking trails, including the Banksia Trail, a gentle 1.9-mile loop trail that is perfect for beginners. The trail takes you through a dense forest filled with eucalyptus trees, and offers stunning views of the surrounding landscape. Toohey Forest is also home to a variety of different wildlife, including koalas and wallabies, making it a great place to connect with nature", trailStartLocation: ["27.5491", "153.0293"], trailEndLocation: ["27.5495", "153.0378"]),
]


struct GuideDetails {
    var name: String
    var age: Int
    var isBooked: Bool
}

let forDisplay = ["Most Popular", "Interesting Hikes", "Adventures", "Nature Love", "Hiking", "Exploring"]


let useApp = ["Find Hikes", "Book Guides", "Saved Hikes", "Search Hikes"]
