//
//  LabQuestionsAPIClient.swift
//  LabQuestions
//
//  Created by Oscar Victoria Gonzalez  on 12/12/19.
//  Copyright © 2019 Alex Paul. All rights reserved.
//

import Foundation

struct LabQuestionsAPIClient {
    static func fetchQuestions(completion: @escaping (Result <[Question], AppError>)-> ()) {
        let labEndpointURLString = "https://5df04c1302b2d90014e1bd66.mockapi.io/questions"
        
        // create a URL from the endpoint string
        guard let url = URL(string: labEndpointURLString) else {
            completion(.failure(.badURL(labEndpointURLString)))
            return
        }
        
        // make a URLRequest object to pass to the NetworkHelper
        let request = URLRequest(url: url)
// set the HTTP method, e.g GET, POST, DELETE, PUT, UPDATE...
//        request.httpMethod = "GET"
//        request.httpBody = data
        
        // this is requred when posting so we inform the POST request
        // of the data  type
        // if we do not provide the header value as "application/json"
        // we will get a decoding error when attempting to decode the JSON
        // request.setValue("application/json",
        
        NetworkHelper.shared.performDataTask(with: request) { (result) in
            switch result {
            case .failure(let appError):
                completion(.failure(.networkClientError(appError)))
            case .success(let data):
                //
                do {
                    let questions = try JSONDecoder().decode([Question].self, from: data)
                    completion(.success(questions))
                } catch {
                    completion(.failure(.decodingError(error)))
                }
            }
        }
    }
    
    static func postQuestion(question: PostedQuestion, completion: @escaping (Result <Bool,AppError>) -> ()) {
        let endPointURLString = "https://5df04c1302b2d90014e1bd66.mockapi.io/questions"
        
        // create a url
        guard let url = URL(string: endPointURLString) else {
            completion(.failure(.badURL(endPointURLString)))
            return
        }
        
        // convert PostedQuestion to Data
        do {
            let data = try JSONEncoder().encode(question)
            
            // configure our URLRequest
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = data
            NetworkHelper.shared.performDataTask(with: request) { (result) in
                switch result {
                case .failure(let appError):
                    completion(.failure(.networkClientError(appError)))
                case .success:
                    completion(.success(true))
                }
            }
        } catch {
            completion(.failure(.encodingError(error)))
        }
    }
}
