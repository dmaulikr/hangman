//
//  ViewController.swift
//  hangman
//
//  Created by Berzan Mikaili on 02.07.17.
//  Copyright © 2017 Berzan Mikaili. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {
	@IBOutlet weak var solutionLabel: UILabel!
	@IBOutlet weak var scoreLabel: UILabel!
	@IBOutlet weak var wrongsLabel: UILabel!
	
	var allWords = [String]()
	var usedWords = [String]()
	var openLetters = [Character]()
	var wordCount = 0
	
	var wrongs: Int = 0 {
		didSet {
			wrongsLabel.text = "Wrongs: \(wrongs)"
		}
	}
	
	var score: Int = 0 {
		didSet {
			scoreLabel.text = "Score: \(score)"
		}
	}
	
	@IBAction func takeGuess(_ sender: Any) {
		let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
		ac.addTextField()
		
		let submitAction = UIAlertAction(title: "Submit", style: .default) {
			[unowned self, ac](action: UIAlertAction) in
			let answer = ac.textFields![0]
			self.submit(answer: answer.text!)
		}
		
		ac.addAction(submitAction)
		
		present(ac, animated: true)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		
		solutionLabel.text = ""
		
		startGame()
		
		navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(restartGame))
	}
	
	func submit(answer: String) {
		let upperAnswer = answer.uppercased()
		let upperSolution = allWords[wordCount].uppercased()
		
		if usedWords.contains(upperAnswer) {
			wrongs += 1
		} else if upperSolution == solutionLabel.text! {
			victory()
		} else if upperAnswer == upperSolution {
			victory()
		} else if upperSolution.contains(upperAnswer) {
			usedWords.append(upperAnswer)
			for (index, letter) in upperSolution.characters.enumerated() {
				if letter == Character(upperAnswer) {
					solutionLabel.text! = replace(myString: solutionLabel.text!, index, letter)
				}
				if upperSolution == solutionLabel.text! {
					victory()
				}
			}
		} else {
			wrongs += 1
		}
		
		if wrongs == 7 {
			let ac = UIAlertController(title: "You lose!", message: "Correct answer would've been \(allWords[wordCount])", preferredStyle: .alert)
			ac.addAction(UIAlertAction(title: "Go again!", style: .default, handler: restartGame))
			present(ac, animated: true)
		}
	}
	
	func victory() {
		score += 1
		let ac = UIAlertController(title: "Well done!", message: "Are you ready to go on?", preferredStyle: .alert)
		ac.addAction(UIAlertAction(title: "Let's go!", style: .default, handler: nextRound))
		present(ac, animated: true)
	}
	
	func restartGame(action: UIAlertAction) {
		wrongs = 0;
		score = 0;
		solutionLabel.text = ""
	
		allWords = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: allWords) as! [String]
		
		for _ in 0..<allWords[wordCount].characters.count {
			self.solutionLabel.text!.append("_")
		}
		
		wordCount += 1

	}
	
	func replace(myString: String, _ index: Int, _ newChar: Character) -> String {
		var chars = Array(myString.characters)     // gets an array of characters
		chars[index] = newChar
		let modifiedString = String(chars)
		return modifiedString
	}
	
	func startGame() {
		
		if let wordsPath = Bundle.main.path(forResource: "wordlist", ofType: "txt") {
			if let words = try? String(contentsOfFile: wordsPath) {
				allWords = words.components(separatedBy: "\n")
			}
		}
		
		allWords = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: allWords) as! [String]
		
		for _ in 0..<allWords[wordCount].characters.count {
			self.solutionLabel.text!.append("_")
		}
		
	}
	
	func nextRound(action: UIAlertAction) {
		solutionLabel.text = ""
		wrongs = 0
		
		for _ in 0..<allWords[wordCount].characters.count {
			self.solutionLabel.text!.append("_")
		}
		
		wordCount += 1
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

}

