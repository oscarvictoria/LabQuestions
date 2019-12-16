//
//  PostedAnswer.swift
//  LabQuestions
//
//  Created by Oscar Victoria Gonzalez  on 12/16/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

struct PostedAnswer: Encodable {
    let questionTitle: String
    let questionId: String 
    let questionLabName: String
    let answerDescription: String
}
