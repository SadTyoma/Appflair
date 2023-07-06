//
//  Car.swift
//  Appflair
//
//  Created by Artem Shuneyko on 5.07.23.
//

import Foundation

struct Car: Codable {
    let id: Int
    let createdAt: Int64
    let brand: String
    let model: String
    let description: String
    let images: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case brand
        case model
        case description
        case images
    }
}
