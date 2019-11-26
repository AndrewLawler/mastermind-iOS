//
//  gameViewController.swift
//  mastermind
//
//  Created by Andrew Lawler on 23/10/2019.
//  Copyright © 2019 andrewlawler. All rights reserved.
//
//  iOS App Development Assignment 1 - Mastermind game:
//  - Selection Bar (Real-Time)
//  - Score Tracking
//  - Guess Tracking
//  - Easy selection/deletion
//
//  Build Date: 24/10/19

import UIKit

// MARK: - Objects

// Guess structure which holds the attributes for a guess
struct Guess {
    var guessOne: String
    var guessTwo: String
    var guessThree: String
    var guessFour: String
}

// structure for a peg
struct Peg {
    var guessOne: String
    var guessTwo: String
    var guessThree: String
    var guessFour: String
}

// structure for a User.Default Key
struct Keys {
    static let pcwins = "pcWins"
    static let userwins = "userWins"
}

// physical viewcontroller to control the views for the game
class gameViewController: UIViewController {
    
    // MARK: - Oulets
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var orangeBtn: UIButton!
    @IBOutlet var greyBtn: UIButton!
    @IBOutlet var greenBtn: UIButton!
    @IBOutlet var blueBtn: UIButton!
    @IBOutlet var yellowBtn: UIButton!
    @IBOutlet var redBtn: UIButton!
    
    @IBOutlet var guessesLabel: UILabel!
    @IBOutlet var currentSelectionOne: UIImageView!
    @IBOutlet var currentSelectionTwo: UIImageView!
    @IBOutlet var currentlSelectionThree: UIImageView!
    @IBOutlet var currentSelectionFour: UIImageView!
    
    @IBOutlet var scoreLabel: UILabel!
    
    // MARK: - Local Variables
    
    // guesses string array which holds the realGuesses in numerical format
    var guesses = [String]()
    // dictionaries for the images. This way i can refer to the image by the button tag
    var images = ["1": "blue", "2": "green", "3": "grey", "4": "orange", "5": "red", "6": "yellow"]
    var pegImages = ["b": "peg", "w": "whitepeg", "bl": "blank"]
    // array which holds
    var chosenImages = [String]()
    // guessArray allows me to index items on an indexPath.item. This is useful as i can store all guesses as objects and refer to them
    var guessArray: [Guess] = []
    // same for peg array
    var pegArray: [Peg] = []
    // pegs holds the peg's before they're made into a Peg
    var pegs = [String]()
    // variables for guesses and wins
    var realGuess = ""
    var colourOutput = ""
    var randomSequence:String = ""
    var userWins = 0
    var computerWins = 0
    // user defaults
    let defaults = UserDefaults.standard
    
    // MARK: - VDL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // adding datasource and delegate to the VM
        tableView.dataSource = self
        tableView.delegate = self
        // calling my initialiser func
        initialiser()
    }
    
    // MARK: - Button Methods
    
    // applies the items into a guess
    @IBAction func okBtn(_ sender: Any) {
        getScore()
        if chosenImages.count==4{
            // blank our the selection bar
            blankSelectionBar()
            // set the guessesLabel counter ++
            guessesLabel.text = "\(guessArray.count+1)"
            // calculate our actual guesses from the chosenImages
            actualGuess(chosenImages)
            // populate our guess into the guessArray
            populateGuess(chosenImages)
            // sort out the pegs
            changePegs()
            // insert the realGuess into the guesses array, we need this array as it stores our answer as a four digit string
            guesses.insert(realGuess, at: 0)
            tableView.isHidden = false
            // are we correct function?
            if checkIfCorrect()==true{
                resultLabel.text = "Well Done! You are Correct"
                userWins += 1
                // set the score
                setScore()
                // reset all arrays
                blankArrays()
            }
            // game over
            else if guesses.count==10 {
                guessesLabel.text = "0"
                tableView.isHidden = true
                // calculate the colours from the numbers
                sequenceToColour()
                resultLabel.text = "GAME OVER - ANSWER WAS: \(colourOutput)"
                computerWins += 1
                setScore()
                // reset all of our arrays
                blankArrays()
                randomGuess()
            }
            realGuess = ""
            chosenImages = []
        }
        tableView.reloadData()
    }
    
    
    // back button tap
    @IBAction func backButton(_ sender: Any) {
        // remove the first image from the chosenImages array
        if chosenImages.count >= 1 {
            chosenImages.remove(at: 0)
        }
        // update the screen selection bar
        currentSelection()
    }
    
    // colour button tap
    @IBAction func buttonTapped(_ sender: UIButton) {
        // get the current score
        getScore()
        resultLabel.text = ""
        // if we have not selected four colours yet, go here
        if chosenImages.count<=3 {
            // add colour into sequence and update screen
            chosenImages.insert(String(sender.tag), at: 0)
            currentSelection()
        }
        // if we have chosen four images
      
        // reload the table view
        tableView.reloadData()
    }
    
    // MARK: - Built-in functions
    
    // blank all arrays to start again
    func blankArrays(){
        pegArray = []
        guessArray = []
        guesses = []
    }
    
    // clear the selection bar
    func blankSelectionBar(){
        currentSelectionOne.image = UIImage(named: "blank")
        currentSelectionTwo.image = UIImage(named: "blank")
        currentlSelectionThree.image = UIImage(named: "blank")
        currentSelectionFour.image = UIImage(named: "blank")
    }
    
    // initialise
    func initialiser(){
        tableView.isHidden = true
        randomGuess()
        print(randomSequence)
        print(colourOutput)
        getScore()
        resultLabel.numberOfLines = 0
    }
    
    // SELECTION BAR
    func currentSelection(){
        // pretty self explanatory. Make the UIImage placeholders blank for all positions which are un-used. If in use, populate with the correct button image
        if chosenImages.count==1 {
            currentSelectionOne.image = UIImage(named: images[chosenImages[0]]!)
            currentSelectionTwo.image = UIImage(named: "blank")
            currentlSelectionThree.image = UIImage(named: "blank")
            currentSelectionFour.image = UIImage(named: "blank")
        }
        else if chosenImages.count==2 {
            currentSelectionOne.image = UIImage(named: images[chosenImages[1]]!)
            currentSelectionTwo.image = UIImage(named: images[chosenImages[0]]!)
            currentlSelectionThree.image = UIImage(named: "blank")
            currentSelectionFour.image = UIImage(named: "blank")
        }
        else if chosenImages.count==3 {
            currentSelectionOne.image = UIImage(named: images[chosenImages[2]]!)
            currentSelectionTwo.image = UIImage(named: images[chosenImages[1]]!)
            currentlSelectionThree.image = UIImage(named: images[chosenImages[0]]!)
            currentSelectionFour.image = UIImage(named: "blank")
        }
        else if chosenImages.count==4{
            currentSelectionOne.image = UIImage(named: images[chosenImages[3]]!)
            currentSelectionTwo.image = UIImage(named: images[chosenImages[2]]!)
            currentlSelectionThree.image = UIImage(named: images[chosenImages[1]]!)
            currentSelectionFour.image = UIImage(named: images[chosenImages[0]]!)
        }
        else {
            currentSelectionOne.image = UIImage(named: "blank")
            currentSelectionTwo.image = UIImage(named: "blank")
            currentlSelectionThree.image = UIImage(named: "blank")
            currentSelectionFour.image = UIImage(named: "blank")
        }
    }
    
    // Printing physical colours from dictionary
    func sequenceToColour(){
        // change sequence to colours
        colourOutput = ""
        for randomSequence in randomSequence {
            // convert numbers to colours
            colourOutput += images[String(randomSequence)]!.uppercased() + " "
        }
    }
    
   // converting chosenImages array into a real numerical guess
    func actualGuess(_ chosenImages:[String]){
        var i = 3
        while i>=0 {
            realGuess += chosenImages[i]
            i = i - 1
        }
    }
    
    // populate the guess array with an actual guess
    func populateGuess(_ chosenImages:[String]){
        // create using Guess object
        guessArray.insert(Guess(guessOne: chosenImages[3], guessTwo: chosenImages[2], guessThree: chosenImages[1], guessFour: chosenImages[0]), at: 0)
    }
    
    // is the guess correct
    func checkIfCorrect() -> Bool {
        if realGuess==randomSequence {
            return true
        }
        else {
            return false
        }
    }
    
    // add in the correct pegs for the guess
    func changePegs(){
        
        pegs = []
        var guess = Array(realGuess)
        var answer = Array(randomSequence)
        
        // add black pegs first
        for i in 0 ... 3 {
            if answer[i]==guess[i] {
                pegs.insert("b", at: 0)
                guess[i] = "a"
                answer[i] = "a"
            }
        }
        
        // remove pegs we've already used
        var i = 0
        while i<answer.count-1 {
            if answer[i]=="a" {
                answer.remove(at: i)
            }
            else {
                i += 1
            }
        }
        // remove pegs we've already used
        var k = 0
        while k<guess.count-1 {
            if guess[k]=="a" {
                guess.remove(at: k)
            }
            else {
                k += 1
            }
        }
        
        var position = 0
        // add white pegs in last
        for i in 0..<guess.count {
            if answer.contains(guess[i]){
                pegs.insert("w", at: 0)
                var g = guess[i]
                for i in 0..<answer.count {
                    if answer[i] == g {
                        position = i
                    }
                }
                answer.remove(at: position)
            }
            else{
                pegs.insert("bl", at: 0)
            }
        }
        // create a peg object to then use in the table view
        pegArray.insert(Peg(guessOne: pegs[0], guessTwo: pegs[1], guessThree: pegs[2], guessFour: pegs[3]), at: 0)
    }
    
    // generate a random guess
    func randomGuess(){
        randomSequence = ""
        for _ in 1..<5 {
            // generate a four digit sequence of numbers from 1-6, these correlate to button tags
            randomSequence += String(Int.random(in: 1 ..< 7))
        }
    }
    
    // MARK: - User Defaults
    
    // set the score
    func setScore(){
        // keep track of user wins and pcwins
        defaults.set(computerWins, forKey: Keys.pcwins)
        defaults.set(userWins, forKey: Keys.userwins)
    }
    
    // get the score
    func getScore(){
        // get the score for the screen
        computerWins = defaults.integer(forKey: Keys.pcwins)
        userWins = defaults.integer(forKey: Keys.userwins)
        scoreLabel.text = "\(userWins)/\(computerWins)"
    }

}
// extension for gameViewController to implement all table view parts
extension gameViewController: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table View Section
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // only load the guesses amount of table row's
        return guesses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "guessCellIdentifier") as! guessCell
        // if the tableView is on show, run this. This stops our table from prematurely loading and causing NSExceptions
        if(tableView.isHidden==false){
            // change the cell image views to match the guessArray items and pegArray items and then root through the image dictionary to show the correct final image.
            cell.imageViewOne.image = UIImage(named: images[guessArray[indexPath.item].guessOne]!)
            cell.imageViewTwo.image = UIImage(named: images[guessArray[indexPath.item].guessTwo]!)
            cell.imageViewThree.image = UIImage(named: images[guessArray[indexPath.item].guessThree]!)
            cell.imageViewFour.image = UIImage(named: images[guessArray[indexPath.item].guessFour]!)
            cell.pegViewOne.image = UIImage(named: pegImages[pegArray[indexPath.item].guessOne]!)
            cell.pegViewTwo.image = UIImage(named: pegImages[pegArray[indexPath.item].guessTwo]!)
            cell.pegViewThree.image = UIImage(named: pegImages[pegArray[indexPath.item].guessThree]!)
            cell.pegViewFour.image = UIImage(named: pegImages[pegArray[indexPath.item].guessFour]!)
        }
        return cell
    }
    
    
}




