//
//  PostedQuestion.swift
//  LabQuestions
//
//  Created by Oscar Victoria Gonzalez  on 12/13/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

struct PostedQuestion: Encodable {
    let title: String
    let labName: String
    let description: String
    let createdAt: String // timeStamp of the created date of the Question.
}
