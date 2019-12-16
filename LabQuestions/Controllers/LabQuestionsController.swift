//
//  ViewController.swift
//  LabQuestions
//
//  Created by Alex Paul on 12/10/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import UIKit

class LabQuestionsController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var refreshControl: UIRefreshControl!
    
    private var questions = [Question]() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        loadQuestions()
        configuredRefreshControl()
    }
    
 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let questionDVC = segue.destination as? QuestionDetailController,
            let indexPath = tableView.indexPathForSelectedRow else {
                fatalError("error")
        }
        
        let updatedQuestion = questions[indexPath.row]
        questionDVC.question = updatedQuestion
    }
    
    func configuredRefreshControl() {
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        
        // programmable target action using objective-c runtime api
        refreshControl.addTarget(self, action: #selector(loadQuestions), for: .valueChanged)
    }
    
    
    @objc
    private func loadQuestions() {
        LabQuestionsAPIClient.fetchQuestions { [weak self] (result) in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
            }
            switch result {
            case .failure(let appError):
                DispatchQueue.main.async {
                    self?.showAlert(title: "App Error", message: "\(appError)")
                }
            case .success(let questions):
                // sorting by most recent Date
                // isoStringToDate() converts an ISO date string to a Date object
                // we need those Date objects so we can sort our lab questions.
                // here we are sorting descending  z -> a 12:50pm, 11:00am
                // ascending < a -> z
                self?.questions = questions.sorted{$0.createdAt.isoStringToDate() > $1.createdAt.isoStringToDate()}
                DispatchQueue.main.async {
                    self?.navigationItem.title = "Lab Questions - (\(questions.count) Questions)"
                }
            }
        }
    }
    
    
}

extension LabQuestionsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "questionCell", for: indexPath)
        let question = questions[indexPath.row]
        cell.textLabel?.text = question.title
        cell.detailTextLabel?.text = question.createdAt.convertISODate() + " - \(question.labName)"
        return cell
    }
}
