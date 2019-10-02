//
//  Movie.swift
//  Cine
//
//  Created by Ma. de Lourdes Chaparro Candiani on 9/25/19.
//  Copyright © 2019 sgh. All rights reserved.
//

import UIKit

struct Movie: Codable{
    var id: String
    var movie_name: String
    var rating: String
    var duration: Int
    var seats: [Seat]
}

struct Seat: Codable{
    var seat_number: Int
    var taken: Bool
}
