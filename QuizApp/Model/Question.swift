//
//  Question.swift
//  QuizApp
//
//  Created by Pradeep Gianchandani on 25/05/21.
//

import Foundation

struct QuestionList: Decodable {
    let questions: [QuestionItem]
}

struct QuestionItem: Decodable {
    let data: Question
}

struct Question: Decodable {
    let metadata: QuestionMetadata
    let stimulus: String
    let options: [Option]
    let marks: Int
}

struct Option: Decodable {
    let label: String
    let score: Int
    let isCorrect: Int
    var isCorrectBool: Bool {
        return isCorrect == 1
    }
}

struct QuestionMetadata: Decodable {
    let duration: Int
}
