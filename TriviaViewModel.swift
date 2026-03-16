//
//  TriviaViewModel.swift
//  TriviaGame
//
//  Created by Ritesh Kafle on 3/16/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class TriviaViewModel: ObservableObject {
    @Published var options = TriviaOptions()
    @Published var questions: [TriviaQuestion] = []
    @Published var selectedAnswers: [UUID: String] = [:]
    @Published var isLoading = false
    @Published var showResultAlert = false
    @Published var score: Int = 0
    
    @Published var categories: [TriviaCategory] = []

    @Published var timeRemaining: Int = 60
    @Published var timerRunning = false

    private let service = TriviaService()
    private var timer: Timer?

    
    func loadCategories() async {
        do {
            categories = try await service.fetchCategories()
        } catch {
            print("Error fetching categories:", error)
        }
    }

    func startGame() async {
        isLoading = true
        do {
            let fetched = try await service.fetchTrivia(options: options)
            questions = fetched
            selectedAnswers = [:]
            score = 0
        } catch {
            print("Error fetching trivia:", error)
        }
        isLoading = false
    }

    func selectAnswer(for question: TriviaQuestion, answer: String) {
        selectedAnswers[question.id] = answer
    }

    func submitQuiz() {
        stopTimer()

        var total = 0
        for q in questions {
            if selectedAnswers[q.id] == q.correct_answer {
                total += 1
            }
        }
        score = total
        showResultAlert = true
    }

    func isAnswerCorrect(for question: TriviaQuestion) -> Bool? {
        guard let selected = selectedAnswers[question.id] else { return nil }
        return selected == question.correct_answer
    }

   

    func startTimer(seconds: Int = 60) {
        timer?.invalidate()
        timeRemaining = seconds
        timerRunning = true

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
            } else {
                self.timer?.invalidate()
                self.timerRunning = false
                self.submitQuiz()
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timerRunning = false
    }
}
