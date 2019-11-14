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
    

    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        scoreLabel = UILabel()
        scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        scoreLabel.textAlignment = .right
        scoreLabel.text = "Score: 0"
        view.addSubview(scoreLabel)
        
        cluesLabel = UILabel()
        cluesLabel.backgroundColor = .red
        cluesLabel.translatesAutoresizingMaskIntoConstraints = false
        cluesLabel.font = UIFont.systemFont(ofSize: 24)
        cluesLabel.text = "CLUES"
        cluesLabel.numberOfLines = 0 // auto scale
        view.addSubview(cluesLabel)
        
        answersLabel = UILabel()
        answersLabel.backgroundColor = .green
        answersLabel.translatesAutoresizingMaskIntoConstraints = false
        answersLabel.font = UIFont.systemFont(ofSize: 24)
        answersLabel.text = "ANSWERS"
        answersLabel.numberOfLines = 0
        answersLabel.textAlignment = .right
        view.addSubview(answersLabel)
        
        currentAnswer = UITextField()
        currentAnswer.backgroundColor = .yellow
        currentAnswer.translatesAutoresizingMaskIntoConstraints = false
        currentAnswer.placeholder = "Tap letters to guess"
        currentAnswer.textAlignment = .center
        currentAnswer.font = UIFont.systemFont(ofSize: 44)
        currentAnswer.isUserInteractionEnabled = false
        view.addSubview(currentAnswer)
        
        // no need to adjust later so don't store as property
        let submit = UIButton(type: .system)
        submit.backgroundColor = .orange
        submit.translatesAutoresizingMaskIntoConstraints = false
        submit.setTitle("SUBMIT", for: .normal)
        view.addSubview(submit)
        
        // no need to adjust later so don't store as property
        let clear = UIButton(type: .system)
        clear.backgroundColor = .purple
        clear.translatesAutoresizingMaskIntoConstraints = false
        clear.setTitle("CLEAR", for: .normal)
        view.addSubview(clear)
        
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
            currentAnswer.topAnchor.constraint(equalToSystemSpacingBelow: cluesLabel.bottomAnchor, multiplier: 20),
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
            clear.heightAnchor.constraint(equalToConstant: 44)
        ])

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

