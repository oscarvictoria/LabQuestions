//
//  AnswerQuestionController.swift
//  LabQuestions
//
//  Created by Oscar Victoria Gonzalez  on 12/16/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class AnswerQuestionController: UIViewController {
    
    var question: Question?
    
    
    @IBOutlet weak var answerTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func post(_ sender: UIBarButtonItem) {
        guard let answerText = answerTextView.text,
            !answerText.isEmpty,
            let question = question else {
                showAlert(title: "Missing fields", message: "Answer iws requred, fellow is waiting")
                return
        }
        
        let postedQuestion = PostedAnswer(questionTitle: question.title, questionId: question.id, questionLabName: question.labName, answerDescription: answerText)
    }
    
    
}
