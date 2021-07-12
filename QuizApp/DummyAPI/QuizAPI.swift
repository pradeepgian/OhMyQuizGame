//
//  QuizAPI.swift
//  QuizApp
//
//  Created by Pradeep Gianchandani on 26/05/21.
//

import Foundation

protocol QuizAPIManagerInjector {
    var quizAPIManager: QuizAPI { get }
}

fileprivate let shared = QuizAPI()

extension QuizAPIManagerInjector {
    var quizAPIManager: QuizAPI {
        return shared
    }
}

class QuizAPI {
    
//    static let shared = QuizAPI() // singleton
    
    func fetchQuestions(completion: (QuestionList?, Error?) -> Void) {
        let jsonData = readLocalJSONFile(name: "questions")
        if let data = jsonData {
            fetchGenericJSONData(jsonData: data, completion: completion)
        }
    }
    
    private func readLocalJSONFile(name: String) -> Data? {
        do {
            if let filePath = Bundle.main.path(forResource: name, ofType: "json") {
                let fileUrl = URL(fileURLWithPath: filePath)
                let data = try Data(contentsOf: fileUrl)
                return data
            }
        } catch {
            print("error: \(error)")
        }
        return nil
    }
    
    private func fetchGenericJSONData<T: Decodable>(jsonData: Data, completion: (T?, Error?) -> ()) {
        do {
            let objects = try JSONDecoder().decode(T.self, from: jsonData)
            // success
            completion(objects, nil)
        } catch {
            completion(nil, error)
        }
    }
    
}
