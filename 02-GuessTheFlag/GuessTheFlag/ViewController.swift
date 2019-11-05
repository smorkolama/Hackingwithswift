//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by Benjamin van den Hout on 24/10/2019.
//  Copyright © 2019 NGTI. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!

    var countries = [String]()
    var correctAnswer = 0
    var score = 0
    var questionsAsked = 0
    let maxQuestions = 10

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Score", style: .plain, target: self, action: #selector(scoreTapped))

        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]

        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1

        button1.layer.borderColor = UIColor.lightGray.cgColor
//        button1.layer.borderColor = UIColor(red: 1.0, green: 0.6, blue: 0.2, alpha: 1.0).cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor

        askQuestion()
    }

    // consider ! to be a synonym for ? with the addition that it adds a flag on the declaration letting the compiler know that the declared value can be implicitly unwrapped. (https://swift.org/blog/iuo/)
    func askQuestion(action: UIAlertAction! = nil) {
        questionsAsked += 1
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        title = "\(countries[correctAnswer].uppercased()) (\(score) points)"
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        if sender.tag == correctAnswer {
            score += 1
            title = "Correct (\(score) points)"
        } else {
            score -= 1
            title = "Wrong (\(score) points)"
        }

        var message: String
        let final = (questionsAsked == maxQuestions) ? "final " : ""
        if sender.tag == correctAnswer {
            message = "Your \(final)score is \(score)"
        } else {
            message = "Wrong! That is the flag of \(countries[sender.tag].uppercased()).\nYour \(final)score is \(score)"
        }

        if questionsAsked == maxQuestions {
            title = "Finished"
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
            reset()
        } else {
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
        }
    }

    func reset() {
        questionsAsked = 0
        score = 0
    }
    
    // share
    @objc func scoreTapped() {
        let ac = UIAlertController(title: "Current score", message: "Your current score is \(score)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
        present(ac, animated: true)
    }
}
