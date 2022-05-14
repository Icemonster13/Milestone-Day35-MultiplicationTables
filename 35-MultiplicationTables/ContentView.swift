//
//  ContentView.swift
//  35-MultiplicationTables
//
//  Created by Michael & Diana Pascucci on 5/1/22.
//

import SwiftUI

struct Question {
    var question: String
    var answer: Int
}

struct ContentView: View {
    // MARK: - @STATE PROPERTIES
    @State private var multiplicationTable = 1
    @State private var totalQuestions = 5
    @State private var questionsRemaining = 5
    @State private var arrayOfQuestions = [Question]()
    @State private var playGame = false
    // @State private var endGame = false
    
    @State private var arrayOfAnswers = [Int]()
    @State private var correctAnswer = 0
    @State private var userAnswer = "0"
    @State private var score = 0
    
    // MARK: - @STATE ANIMATION PROPERTIES
    @State private var scaleAmount = 1.0
    @State private var rotationDegrees = 0.0
    @State private var animationAmount = 0.0
    
    // MARK: - CONSTANTS
    private let questionCount = [5,10,20]
    private let animalArray = [
        "bear", "buffalo", "chick", "chicken", "cow", "crocodile", "dog",
        "duck", "elephant", "frog", "giraffe", "goat", "gorilla", "hippo",
        "horse", "monkey", "moose", "narwhal", "owl", "panda", "parrot",
        "penguin", "pig", "rabbit", "rhino", "sloth", "snake", "walrus",
        "whale", "zebra"]
    
    // MARK: - COMPUTED PROPERTIES
    
    // MARK: - METHODS
    func startGame() {
        questionsRemaining = totalQuestions
        arrayOfQuestions.removeAll()
        for i in 1...12 {
            let newQuestion = Question(question: "\(multiplicationTable) x \(i) =", answer: multiplicationTable * i)
            arrayOfQuestions.append(newQuestion)
        }
        arrayOfQuestions.shuffle()
        switch totalQuestions {
        case 10:
            // Remove the last two questions in the array
            while arrayOfQuestions.count > totalQuestions {
                arrayOfQuestions.removeLast()
            }
        case 20:
            for i in 5...12 {
                let newQuestion = Question(question: "\(multiplicationTable) x \(i)", answer: multiplicationTable * i)
                arrayOfQuestions.append(newQuestion)
            }
            arrayOfQuestions.shuffle()
        default:
            // Remove the last seven questions in the array
            while arrayOfQuestions.count > totalQuestions {
                arrayOfQuestions.removeLast()
            }
        }
        arrayOfQuestions.shuffle()
        getAnswers()
        playGame = true
    }
    
    func getAnswers() {
        arrayOfAnswers.removeAll()
        // This is the correct answer
        arrayOfAnswers.append(arrayOfQuestions[totalQuestions-questionsRemaining].answer)
        // These are the wrong answers
        while arrayOfAnswers.count < 4 {
            let randomNumber = Int.random(in: 0..<totalQuestions)
            if !arrayOfAnswers.contains(arrayOfQuestions[randomNumber].answer) {
                arrayOfAnswers.append(arrayOfQuestions[randomNumber].answer)
            }
        }
        print(arrayOfAnswers)
        arrayOfAnswers.shuffle()
    }
    
    func checkAnswer(given: Int, correct: Int) {
        if questionsRemaining > 1 {
            score += 1
            questionsRemaining -= 1
            getAnswers()
        } else if questionsRemaining == 1 {
            scaleAmount -= 1
            rotationDegrees += 360
            questionsRemaining -= 1
            score += 1
        }
    }
    
    func resetGame() {
        scaleAmount = 1.0
        rotationDegrees = 0.0
        score = 0
        playGame = false
    }
    
    // MARK: - BODY
    var body: some View {
        ZStack {
            Color("AccentColor1")
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Multiply The Fun")
                    .font(.system(size: 60, weight: .heavy, design: .rounded))
                
                if playGame {       // Show the Game Page
                    Spacer()
                    VStack(spacing: 30) {
                        Text(arrayOfQuestions.count > 0 ?
                             questionsRemaining > 0 ?
                             arrayOfQuestions[totalQuestions-questionsRemaining].question :
                                "Finished" : "Missing")
                            .fontWeight(.heavy)
                            .font(.system(size: 70))
                            .frame(width: 300, height: 150, alignment: .center)
                            .background(Color("AccentColor3"))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .rotation3DEffect(.degrees(rotationDegrees), axis: (x: 1, y: 1, z: 0))
                            .animation(.default, value: rotationDegrees)
                        HStack {
                            ForEach(0..<4) { number in
                                Button {
                                    checkAnswer(given: arrayOfAnswers[number],
                                                correct: arrayOfQuestions[totalQuestions-questionsRemaining].answer)
                                } label: {
                                    Text(arrayOfAnswers.count > 0 ? String(arrayOfAnswers[number]) : "0")
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                }
                                .padding()
                                .frame(width: 75, height: 75, alignment: .center)
                                .background(Color("AccentColor4"))
                                .clipShape(Circle())
                            }
                            .scaleEffect(scaleAmount)
                            .animation(.easeInOut(duration: 1)
                                .repeatCount(3, autoreverses: true), value: scaleAmount)
                        }
                        Text("Your score is: \(score) of \(totalQuestions)")
                            .fontWeight(.bold)
                            .titleStyle()
                    }
                    Spacer()
                    Button {
                        resetGame()
                    } label: {
                        Text("RESET")
                            .fontWeight(.bold)
                            .titleStyle()
                    }
                    .buttonStyle()
                    Spacer()
                } else {            // Show the Settings Page
                    Image(animalArray[Int.random(in: 0..<animalArray.count)])
                        .frame(width: 200, height: 200, alignment: .center)
                        .background(Color("AccentColor3"))
                        .clipShape(RoundedRectangle(cornerRadius: 50, style: .circular))
                    Section {
                        Picker("Number selection", selection: $multiplicationTable) {
                            ForEach(1..<13, id: \.self) {
                                Text("\($0)")
                            }
                        }
                        .pickerStyle(.segmented)
                    } header: {
                        Text("Choose your Multiplication Table:")
                            .fontWeight(.bold)
                            .titleStyle()
                    }
                    Section {
                        Picker("Question Count", selection: $totalQuestions) {
                            ForEach(questionCount, id: \.self) {
                                Text("\($0)")
                            }
                        }
                        .pickerStyle(.segmented)
                    } header: {
                        Text("How many questions?")
                            .fontWeight(.bold)
                            .titleStyle()
                    }
                    Spacer()
                    Button {
                        startGame()
                    } label: {
                        Text("START")
                            .fontWeight(.bold)
                            .titleStyle()
                    }
                    .buttonStyle()
                    Spacer()
                }
            }
            .padding()
            .foregroundColor(Color("AccentColor4"))
        } //: ZStack
    } //: Body
} //: Struct

// MARK: - VIEW MODIFIERS AND EXTENSIONS
struct MyButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(width: 150, height: 60, alignment: .center)
            .background(Color("AccentColor2"))
            .clipShape(Capsule())
    }
}

struct MyTitle: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.title2)
            .multilineTextAlignment(.center)
    }
}

extension View {
    func buttonStyle() -> some View {
        modifier(MyButton())
    }
    
    func titleStyle() -> some View {
        modifier(MyTitle())
    }
}



// MARK: - PREVIEW
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewInterfaceOrientation(.portraitUpsideDown)
        }
    }
}
