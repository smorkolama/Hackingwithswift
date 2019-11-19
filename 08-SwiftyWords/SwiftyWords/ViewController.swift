//
//  ViewController.swift
//  SwiftyWords
//
//  Created by Benjamin van den Hout on 14/11/2019.
//  Copyright © 2019 Benjamin van den Hout. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var cluesLabel: UILabel!
    var answersLabel: UILabel!
    var currentAnswer: UITextField!
    var scoreLabel: UILabel!
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    var score = 0 {
        didSet { // property observer
            scoreLabel.text = "Score: \(score)"
        }
    }
    var level = 1

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
//        cluesLabel.backgroundColor = .red
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0 // auto scale
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
//        answersLabel.backgroundColor = .green
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.numberOfLines = 0
        answersLabel.textAlignment = .right
        view.addSubview(answersLabel)
        
        currentAnswer = UITextField()
//        currentAnswer.backgroundColor = .yellow
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        // no need to adjust later so don't store as property
        let submit = UIButton(type: .system)
//        submit.backgroundColor = .orange
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        submit.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        view.addSubview(submit)
        
        // no need to adjust later so don't store as property
        let clear = UIButton(type: .system)
//        clear.backgroundColor = .purple
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        clear.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
        view.addSubview(clear)
        
        // no need to adjust later so don't store as property
        let buttonsView = UIView()
//        buttonsView.backgroundColor = .cyan
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            scoreLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            scoreLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            // pin top of clues label to bottom of score label
            cluesLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            // pin leading edge of clues label to leading edge of layout margin, adding 100 for space
            cluesLabel.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor, constant: 100),
            // make the clues label 60% of layout margins minus 100
            cluesLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.6, constant: -100),
            // also pin top of answerslabel to bottom of score label
            answersLabel.topAnchor.constraint(equalTo: scoreLabel.bottomAnchor),
            // make answers label stick to trailing edge of layout margins minus 100
            answersLabel.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor, constant: -100),
            // make answers label take up 40% of available space minus 100
            answersLabel.widthAnchor.constraint(equalTo: view.layoutMarginsGuide.widthAnchor, multiplier: 0.4, constant: -100),
            // make answers label match height of clues label
            answersLabel.heightAnchor.constraint(equalTo: cluesLabel.heightAnchor),
            // center textfield, width is 50% of view
            currentAnswer.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            currentAnswer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            // 20 points below clues label
            currentAnswer.topAnchor.constraint(equalTo: cluesLabel.bottomAnchor, constant: 20),
            // submit bottom is below current answer
            submit.topAnchor.constraint(equalTo: currentAnswer.bottomAnchor),
            // submit is 100 to the left of center
            submit.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -100),
            // submit height is 44
            submit.heightAnchor.constraint(equalToConstant: 44),
            // clear is 100 to the right of center
            clear.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 100),
            // clear Y position is same as submit
            clear.centerYAnchor.constraint(equalTo: submit.centerYAnchor),
            // clear height is 44
            clear.heightAnchor.constraint(equalToConstant: 44),
            // buttons width/height
            buttonsView.widthAnchor.constraint(equalToConstant: 750),
            buttonsView.heightAnchor.constraint(equalToConstant: 320),
            // buttons center horizontally
            buttonsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            // top anchor is bottom of submit button plus 20
            buttonsView.topAnchor.constraint(equalTo: submit.bottomAnchor, constant: 20),
            // pin to bottom of layout margin -20
            buttonsView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -20)
        ])

        // clues and answers should be the ones to stretch to fill screen, default is 250 and lower means less effort to keep them in original size
        cluesLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        answersLabel.setContentHuggingPriority(UILayoutPriority(1), for: .vertical)
        
        let width = 150
        let height = 80
        
        // don't use translatesAutoresizingMaskIntoConstraints = false here, in this case it makes sense to auto generate constraints based on size
        for row in 0..<4 {
            for col in 0..<5 {
                let letterButton = UIButton(type: .system)
                letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 36)
                letterButton.setTitle("WWW", for: .normal)
                
                // calculate the frame of this button using column and row
                let frame = CGRect(x: col * width, y: row * height, width: width, height: height)
                letterButton.frame = frame
                
                buttonsView.addSubview(letterButton)
                letterButton.addTarget(self, action: #selector(letterTapped), for: .touchUpInside)
                letterButtons.append(letterButton)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        loadLevel()
    }

    @objc func letterTapped(_ sender: UIButton) {
        guard let buttonTitle = sender.titleLabel?.text else { return }
        currentAnswer.text = currentAnswer.text?.appending(buttonTitle)
        activatedButtons.append(sender)
        sender.isHidden = true
    }
    
    @objc func submitTapped(_ sender: UIButton) {
        guard let answerText = currentAnswer.text else { return }
        
        if let solutionPosition = solutions.firstIndex(of: answerText) {
            activatedButtons.removeAll()
            
            var splitAnswers = answersLabel.text?.components(separatedBy: "\n")
            splitAnswers?[solutionPosition] = answerText
            answersLabel.text = splitAnswers?.joined(separator: "\n")
            
            currentAnswer.text = ""
            score += 1
            
            if score % 7 == 0 {
                let ac = UIAlertController(title: "Well done", message: "Are you ready for the next level?", preferredStyle: .alert)
                ac.addAction(UIAlertAction(title: "Let's go", style: .default, handler: levelUp))
                present(ac, animated: true)
            }
        }
    }
    
    @objc func clearTapped(_ sender: UIButton) {
        currentAnswer.text = ""
        for button in activatedButtons {
            button.isHidden = false
        }
        
        activatedButtons.removeAll()
    }
    
    func loadLevel() {
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        if let levelFileURL = Bundle.main.url(forResource: "level\(level)", withExtension: "txt") {
            if let levelContents = try? String(contentsOf: levelFileURL) {
                var lines = levelContents.components(separatedBy: "\n")
                lines.shuffle()
                
                // Sample data: POR|TL|AND: Hipster heartland
                for (index, line) in lines.enumerated() { // use enumerated because you get the index
                    let parts = line.components(separatedBy: ":") // separate answer and clue first
                    let answer = parts[0]
                    let clue = parts[1]
                    
                    clueString += "\(index + 1). \(clue)\n"
                    
                    let solutionWord = answer.replacingOccurrences(of: "|", with: "") // word we are looking for
                    solutionString += "\(solutionWord.count) letters\n"
                    solutions.append(solutionWord)
                    
                    let bits = answer.components(separatedBy: "|") // get button contents
                    letterBits += bits
                }
            }
        }

        cluesLabel.text = clueString.trimmingCharacters(in: .whitespacesAndNewlines)
        answersLabel.text = solutionString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        letterBits.shuffle()
        if letterBits.count == letterButtons.count {
            for i in 0 ..< letterButtons.count {
                letterButtons[i].setTitle(letterBits[i], for: .normal)
            }
        }
    }
    
    func levelUp(action: UIAlertAction)
    {
        level += 1
        solutions.removeAll(keepingCapacity: true)

        loadLevel()

        for button in letterButtons {
            button.isHidden = false
        }
    }
}

