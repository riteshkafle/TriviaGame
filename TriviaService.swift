//
//  TriviaService.swift
//  TriviaGame
//
//  Created by Ritesh Kafle on 3/16/26.
//

import Foundation

final class TriviaService {
    func fetchTrivia(options: TriviaOptions) async throws -> [TriviaQuestion] {
        var components = URLComponents(string: "https://opentdb.com/api.php")!
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "amount", value: "\(options.amount)")
        ]

        if let categoryId = options.categoryId {
            queryItems.append(URLQueryItem(name: "category", value: "\(categoryId)"))
        }
        if let difficulty = options.difficulty {
            queryItems.append(URLQueryItem(name: "difficulty", value: difficulty))
        }
        if let type = options.type {
            queryItems.append(URLQueryItem(name: "type", value: type))
        }

        components.queryItems = queryItems

        let (data, _) = try await URLSession.shared.data(from: components.url!)
        let decoded = try JSONDecoder().decode(TriviaResponse.self, from: data)
        return decoded.results
    }
    
    func fetchCategories() async throws -> [TriviaCategory] {
        let url = URL(string: "https://opentdb.com/api_category.php")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoded = try JSONDecoder().decode(TriviaCategoryResponse.self, from: data)
        return decoded.trivia_categories
    }

}
