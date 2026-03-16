//
//  TriviaModels.swift
//  TriviaGame
//
//  Created by Ritesh Kafle on 3/16/26.
//
import Foundation

struct TriviaResponse: Codable {
    let response_code: Int
    let results: [TriviaQuestion]
}

struct TriviaQuestion: Codable, Identifiable {
    let id = UUID()
    let category: String
    let type: String
    let difficulty: String
    let question: String
    let correct_answer: String
    let incorrect_answers: [String]
    
 
    let answers: [String]
    
    private enum CodingKeys: String, CodingKey {
        case category, type, difficulty, question, correct_answer, incorrect_answers
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        category = try container.decode(String.self, forKey: .category)
        type = try container.decode(String.self, forKey: .type)
        difficulty = try container.decode(String.self, forKey: .difficulty)
        question = try container.decode(String.self, forKey: .question)
        correct_answer = try container.decode(String.self, forKey: .correct_answer)
        incorrect_answers = try container.decode([String].self, forKey: .incorrect_answers)
        answers = (incorrect_answers + [correct_answer]).shuffled()
    }
}

struct TriviaOptions {
    var amount: Int = 10
    var categoryId: Int? = nil      
    var difficulty: String? = nil
    var type: String? = nil
    
    var timerEnabled: Bool = true
    var timerSeconds: Int = 60
}

struct TriviaCategoryResponse: Codable {
    let trivia_categories: [TriviaCategory]
}

struct TriviaCategory: Codable, Identifiable, Hashable {
    let id: Int
    let name: String
}
