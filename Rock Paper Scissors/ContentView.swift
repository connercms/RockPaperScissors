//
//  ContentView.swift
//  Rock Paper Scissors
//
//  Created by Conner Shannon on 10/18/19.
//  Copyright © 2019 Conner Shannon. All rights reserved.
//

import SwiftUI



struct ContentView: View {
    let colors: [String: Color] = [
        "teal": Color(red: 0.49, green: 0.89, blue: 0.98),
        "lightBlue": Color(red: 0.35, green: 0.79, blue: 0.97),
        "hotPink": Color(red: 0.9, green: 0.1, blue: 0.5),
        "blue": Color(red: 0.11, green: 0.10, blue: 0.6),
        "purple": Color(red: 0.11, green: 0.07, blue: 0.27)
    ]
    let options = ["Rock", "Paper", "Scissors"]
    @State private var computerSelection: Int = Int.random(in: 0 ..< 3)
    @State private var showChoiceText: Bool = false
    @State private var showComputerChoice: Bool = false
    @State private var winnerText: String = ""
    @State private var playerScore: Int = 0
    @State private var computerScore: Int = 0
    @State private var gameDidEnd: Bool = false
    @State private var alertTitle = ""
    
    func resetComputerChoice() {
        // Hide the choice text and give computer new random selection
        showChoiceText = false
        showComputerChoice = false
        computerSelection = Int.random(in: 0 ..< 3)
    }
    
    func reset() {
        // Reset the game
        resetComputerChoice()
        playerScore = 0
        computerScore = 0
    }
    
    func makeSelection(_ selection: Int) {
        // Show text after a timeout to create some suspense
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.showChoiceText = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.showComputerChoice = true
                
                if selection == self.computerSelection {
                    // It was a draw
                    self.winnerText = "Draw!"
                } else if (selection - self.computerSelection) % 3 == 1 {
                    self.playerScore += 1
                    self.winnerText = "You win this round!"
                } else {
                    self.computerScore += 1
                    self.winnerText = "You lost this round."
                }
                
                if (self.playerScore == 3 || self.computerScore == 3) {
                    // Best of 3, if someone reached 3 points end the game
                    self.gameDidEnd = true
                    
                    // Set the end game alert title to show results
                    if (self.playerScore == 3) {
                        self.alertTitle = "You win!"
                    } else if (self.computerScore == 3) {
                        self.alertTitle = "You lost!"
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    // Give the computer a new random selection
                    self.resetComputerChoice()
                }
            }
            
        }
    }
    
    private var computerText: some View {
        VStack(spacing: 20) {
            if showChoiceText {
                Text("computer chose...")
                    .foregroundColor(.white)
            }
            if showComputerChoice {
                Text("\(options[computerSelection])")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundColor(colors["blue", default: .black])
                Text(winnerText)
                    .fontWeight(.bold)
                    .font(.callout)
                    .layoutPriority(100)
                    .foregroundColor(.white)
            }
        }
    }
    
    private var buttons: some View {
        VStack(spacing: 20) {
            if !showChoiceText && !showComputerChoice {
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        self.makeSelection(number)
                    }) {
                        ZStack {
                            RadialGradient(gradient: Gradient(colors: [self.colors["blue", default: .white], self.colors["purple", default: .white]]), center: .center, startRadius: 50, endRadius: 200)
                            
                            
                            Text("\(self.options[number].uppercased())")
                                .foregroundColor(self.colors["teal", default: .black])
                                .padding()
                        }
                        .clipShape(Rectangle())
                        .overlay(Rectangle().stroke(self.colors["blue", default: .black], lineWidth: 2))
                    }
                }
            }
        }.padding()
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [colors["teal", default: .white], colors["hotPink", default: .white]]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Group {
                        Text("Your score: \(playerScore)")
                            .foregroundColor(.white)
                        
                        Text("Computer score: \(computerScore)")
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    computerText
                    
                    buttons
                    
                    Spacer()
                        
                        .alert(isPresented: $gameDidEnd) {
                            Alert(title: Text(self.alertTitle), message: Text("Good game, thanks for playing."), dismissButton: .default(Text("Replay")) {
                                self.reset()
                                })
                    }
                    .navigationBarTitle(Text("Rock, Paper, Scissors"))
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
