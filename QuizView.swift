//
//  QuizView.swift
//  TriviaGame
//
//  Created by Ritesh Kafle on 3/16/26.
//

import SwiftUI

struct QuizView: View {
    @ObservedObject var viewModel: TriviaViewModel

    var body: some View {
        List {
            ForEach(viewModel.questions) { question in
                VStack(alignment: .leading, spacing: 8) {
                    Text(htmlDecoded(question.question))
                        .font(.headline)

                    ForEach(question.answers, id: \.self) { answer in
                        AnswerRow(
                            text: htmlDecoded(answer),
                            isSelected: viewModel.selectedAnswers[question.id] == answer
                        )
                        .onTapGesture {
                            viewModel.selectAnswer(for: question, answer: answer)
                        }
                    }

                    if viewModel.showResultAlert,
                       let isCorrect = viewModel.isAnswerCorrect(for: question) {
                        Text(isCorrect ? "Correct" : "Incorrect")
                            .font(.subheadline)
                            .foregroundColor(isCorrect ? .green : .red)
                    }
                }
                .padding(.vertical, 8)
            }
        }
        .navigationTitle("Quiz")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if viewModel.options.timerEnabled {
                    Text("Time: \(viewModel.timeRemaining)s")
                        .monospacedDigit()
                }
            }
            ToolbarItem(placement: .bottomBar) {
                Button("Submit") {
                    viewModel.submitQuiz()
                }
                .disabled(viewModel.questions.isEmpty)
            }
        }
        .onAppear {
            if viewModel.options.timerEnabled {
                viewModel.startTimer(seconds: viewModel.options.timerSeconds)
            } else {
                viewModel.stopTimer()
            }
        }
        .onDisappear {
            viewModel.stopTimer()
        }
        .alert("Your Score", isPresented: $viewModel.showResultAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("You scored \(viewModel.score) / \(viewModel.questions.count)")
        }
    }
}

struct AnswerRow: View {
    let text: String
    let isSelected: Bool

    var body: some View {
        HStack {
            Text(text)
                .foregroundColor(.primary)
            Spacer()
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.blue)
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? Color.blue : Color.gray.opacity(0.3), lineWidth: 2)
        )
    }
}