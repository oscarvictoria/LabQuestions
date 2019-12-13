//
//  CreateQuestionController.swift
//  LabQuestions
//
//  Created by Alex Paul on 12/11/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class CreateQuestionController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var questionTextView: UITextView!
    @IBOutlet weak var labPickerView: UIPickerView!
    
    // data for our picker view
    private let labs = ["Concurrency", "Comic", "Parsing JSON - Weather, Color, User", "Image and Error Handeling", "StocksPeople", "Intro to Unit Testing - Jokes, Star Wars, Trivia"].sorted() // acesnding by default a - z
    
    // labName will be the current selected row in the picker view
    private var labName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // comfigure the picker view
        labPickerView.dataSource = self
        labPickerView.delegate = self
        
        // variable to track the current selected lab in the picker view.
        
        labName = labs.first
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // we want to change the color and border width of
        // the text view
        // experiment with shadows on views
        // every view has a CALayer - CA Core Animation
        // semantic colors adapt to light or dark mode
        questionTextView.layer.borderColor = UIColor.systemGreen.cgColor
        questionTextView.layer.borderWidth = 7
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createQuestion(_ sender: UIBarButtonItem) {
        // 3 required parameters to create a PostQuestion
        guard let questionTitle = titleTextField.text,
            !questionTitle.isEmpty,
            let labName = labName,
            let labDescription = questionTextView.text,
            !labDescription.isEmpty else {
            showAlert(title: "Missing Fields", message: "Title, Description are required")
                return
        }
        let question = PostedQuestion(title: questionTitle,
                                      labName: labName,
                                      description: labDescription,
                                      createdAt: String.getISOTimestamp())
        
        LabQuestionsAPIClient.postQuestion(question: question) { [weak self] (result) in
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error posting question", message: "\(appError)")
                }
            case .success:
                DispatchQueue.main.async {
                    self?.showAlert(title: "Success", message: "\(questionTitle) was posted")
                }
            }
        }
    }
}

extension CreateQuestionController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        labs.count
    }
}

extension CreateQuestionController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return labs[row]
    }
}
