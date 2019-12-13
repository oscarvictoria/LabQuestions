//
//  Question.swift
//  LabQuestions
//
//  Created by Oscar Victoria Gonzalez  on 12/12/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

struct Question: Decodable {
    let id: String
    let name: String // random user name
    let avatar: String // random user avatar
    let createdAt: String // creating a date stamp
    let title: String?
    let description: String
    let labName: String
}
