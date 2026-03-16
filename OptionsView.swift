//
//  OptionsView.swift
//  TriviaGame
//
//  Created by Ritesh Kafle on 3/16/26.
//

import SwiftUI

struct OptionsView: View {
    @StateObject private var viewModel = TriviaViewModel()
    @State private var navigateToQuiz = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Number of Questions") {
                    Stepper("\(viewModel.options.amount)",
                            value: $viewModel.options.amount,
                            in: 5...20)
                }

                Section("Difficulty") {
                    Picker("Difficulty", selection: Binding(
                        get: { viewModel.options.difficulty ?? "" },
                        set: { viewModel.options.difficulty = $0.isEmpty ? nil : $0 }
                    )) {
                        Text("Any").tag("")
                        Text("Easy").tag("easy")
                        Text("Medium").tag("medium")
                        Text("Hard").tag("hard")
                    }
                    .pickerStyle(.segmented)
                }

                Section("Type") {
                    Picker("Type", selection: Binding(
                        get: { viewModel.options.type ?? "" },
                        set: { viewModel.options.type = $0.isEmpty ? nil : $0 }
                    )) {
                        Text("Any").tag("")
                        Text("Multiple").tag("multiple")
                        Text("True / False").tag("boolean")
                    }
                    .pickerStyle(.segmented)
                }

                Section("Category (optional)") {
                    Picker("Category", selection: Binding(
                        get: { viewModel.options.categoryId ?? 0 },
                        set: { viewModel.options.categoryId = $0 == 0 ? nil : $0 }
                    )) {
                        Text("Any Category").tag(0)
                        ForEach(viewModel.categories) { category in
                            Text(category.name).tag(category.id)
                        }
                    }
                }
                
                Section("Timer (optional)") {
                    Toggle("Enable Timer", isOn: $viewModel.options.timerEnabled)
                    Stepper("Seconds: \(viewModel.options.timerSeconds)",
                            value: $viewModel.options.timerSeconds,
                            in: 10...300,
                            step: 10)
                    .disabled(!viewModel.options.timerEnabled)
                }
            }
            .navigationTitle("Trivia Game")
            .task {
                if viewModel.categories.isEmpty {
                    await viewModel.loadCategories()
                }
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        Task {
                            await viewModel.startGame()
                            navigateToQuiz = true
                        }
                    } label: {
                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            Text("Start Game")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .navigationDestination(isPresented: $navigateToQuiz) {
                QuizView(viewModel: viewModel)
            }
        }
    }
}
