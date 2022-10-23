//
//  ViewController.swift
//  Flashcards
//
//  Created by Christopher Crowley on 9/17/22.
//

import UIKit

struct Flashcard {
    var question: String
    var answer: String
    var extraAnswerOne: String
    var extraAnswerTwo: String
}

class ViewController: UIViewController {

    @IBOutlet weak var card: UIView!
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var backLabel: UILabel!

    @IBOutlet weak var btnContainer: UIView!
    @IBOutlet weak var btnOptionOne: UIButton!
    @IBOutlet weak var btnOptionTwo: UIButton!
    @IBOutlet weak var btnOptionThree: UIButton!
  
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    
    
    
    //Array to hold our flashcards
    var flashcards = [Flashcard]()
    
    //Current flashcard index
    var currentIndex = 0
    
    //Button to remember what the correct answer is
    var correctAnswerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        card.layer.cornerRadius = 20.0
        card.layer.shadowRadius = 15.0
        card.layer.shadowOpacity = 0.3
        frontLabel.layer.cornerRadius = 20.0
        frontLabel.clipsToBounds = true
        frontLabel.backgroundColor = UIColor(patternImage: UIImage(named: "paper")!)
        backLabel.layer.cornerRadius = 20.0
        backLabel.clipsToBounds = true
        backLabel.backgroundColor = UIColor(patternImage: UIImage(named: "answerpaper")!)
        
        btnOptionOne.layer.borderWidth = 3.0
        btnOptionOne.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        btnOptionOne.layer.cornerRadius = 20.0
        btnOptionTwo.layer.borderWidth = 3.0
        btnOptionTwo.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        btnOptionTwo.layer.cornerRadius = 20.0
        btnOptionThree.layer.borderWidth = 3.0
        btnOptionThree.layer.borderColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        btnOptionThree.layer.cornerRadius = 20.0
        
        readSavedFlashcards()
        
        if flashcards.count == 0 {
            updateFlashcard(question: "Enter question", answer: "Enter answer", extraAnswerOne: "Extra answer one", extraAnswerTwo: "Extra answer two", isExisting: false)
        } else {
            updateLabels()
            updateNextPrevButtons()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //First start with the flashcard invisible and slightly smaller in size
        card.alpha = 0.0
        btnOptionOne.alpha = 0.0
        btnOptionTwo.alpha = 0.0
        btnOptionThree.alpha = 0.0
        card.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        btnOptionOne.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        btnOptionTwo.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        btnOptionThree.transform = CGAffineTransform.identity.scaledBy(x: 0.75, y: 0.75)
        
        //Animation
        UIView.animate(withDuration: 0.6, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
            self.card.alpha = 1.0
            self.btnOptionOne.alpha = 1.0
            self.btnOptionTwo.alpha = 1.0
            self.btnOptionThree.alpha = 1.0
            self.card.transform = CGAffineTransform.identity
            self.btnOptionOne.transform = CGAffineTransform.identity
            self.btnOptionTwo.transform = CGAffineTransform.identity
            self.btnOptionThree.transform = CGAffineTransform.identity
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //We know the destination of the segue is the Navigation Controller
        let navigationController = segue.destination as! UINavigationController
        
        //We know the Navigation Controller only contains a Creation View Controller
        let creationController = navigationController.topViewController as! CreationViewController
        
        //We set the flashcardsController property to self
        creationController.flashcardsController = self
        
        if segue.identifier == "EditSegue" {
            creationController.initialQuestion = frontLabel.text
            creationController.initialAnswer = backLabel.text
        }


    }

    @IBAction func didTapFlashcard(_ sender: Any) {
        flipFlashcard()
    }
    
    func flipFlashcard() {
        UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight) {
            self.frontLabel.isHidden = !self.frontLabel.isHidden
        }
    }
    
    @IBAction func didTapOptionOne(_ sender: Any) {
        if btnOptionOne == correctAnswerButton {
            flipFlashcard()
        } else {
            frontLabel.isHidden = false
            btnOptionOne.isEnabled = false
        }
    }
    @IBAction func didTapOptionTwo(_ sender: Any) {
        if btnOptionTwo == correctAnswerButton {
            flipFlashcard()
        } else {
            frontLabel.isHidden = false
            btnOptionTwo.isEnabled = false
        }
    }
    @IBAction func didTapOptionThree(_ sender: Any) {
        if btnOptionThree == correctAnswerButton {
            flipFlashcard()
        } else {
            frontLabel.isHidden = false
            btnOptionThree.isEnabled = false
        }
    }
    @IBAction func didTapOnNext(_ sender: Any) {
        
        //Increase current index
        currentIndex = currentIndex + 1
                
        //Update buttons
        updateNextPrevButtons()
        
        animateCardOut(buttonType: "next")
    }
    @IBAction func didTapOnPrev(_ sender: Any) {
        
        //Decrease current index
        currentIndex = currentIndex - 1
        
        //Update labels
        updateLabels()
        
        //Update buttons
        updateNextPrevButtons()
        
        animateCardOut(buttonType: "prev")

    }
    
    func animateCardOut(buttonType: String) {
        UIView.animate(withDuration: 0.3, animations: {
            if (buttonType == "next"){
                self.card.transform = CGAffineTransform.identity.translatedBy(x: -500.0, y: 0.0)
                self.btnContainer.transform = CGAffineTransform.identity.translatedBy(x: -500.0, y: 0.0)}
            else {
                self.card.transform = CGAffineTransform.identity.translatedBy(x: 500.0, y: 0.0)
                self.btnContainer.transform = CGAffineTransform.identity.translatedBy(x: 500.0, y: 0.0)}
                
            
        }, completion: {finished in
            
            //Update labels
            self.updateLabels()
            
            //Run other animation
            self.animateCardIn(buttonType: buttonType)
        })
    }
    
    func animateCardIn(buttonType: String) {
        
        if (buttonType == "next"){
                self.card.transform = CGAffineTransform.identity.translatedBy(x: 500.0, y: 0.0)
                self.btnContainer.transform = CGAffineTransform.identity.translatedBy(x: 500.0, y: 0.0)
               }
        else {self.card.transform = CGAffineTransform.identity.translatedBy(x: -500.0, y: 0.0)
            self.btnContainer.transform = CGAffineTransform.identity.translatedBy(x: -500.0, y: 0.0)
               }
        
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity
            self.btnContainer.transform = CGAffineTransform.identity
        }
    }
                       
    
    @IBAction func didTapOnDelete(_ sender: Any) {
        
        //Show confirmation
        let alert = UIAlertController(title: "Delete flashcard", message: "Are you sure you want to delete this card?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) {
            action in self.deleteCurrentFlashcard()
        }
        alert.addAction(deleteAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func deleteCurrentFlashcard() {
        //Delete current
        flashcards.remove(at: currentIndex)
        
        //Special case: Check if last card was deleted
        if currentIndex > flashcards.count - 1 {
            currentIndex = flashcards.count-1
        }
        updateNextPrevButtons()
        updateLabels()
        saveAllFlashcardsToDisk()
        
    }
    
    func updateFlashcard(question: String, answer: String, extraAnswerOne: String, extraAnswerTwo: String, isExisting: Bool) {
        
        let flashcard = Flashcard(question: question, answer: answer, extraAnswerOne: extraAnswerOne, extraAnswerTwo: extraAnswerTwo)
        
        if isExisting {
            
            //Replace existing flashcard
            flashcards[currentIndex] = flashcard
        } else {
            //Adding flashcard in the flashcards array
            flashcards.append(flashcard)
            
            //Logging to the console
            print("Added a new Flashcard")
            print("We now have \(flashcards.count) flashcards")
            
            //Update current index
            currentIndex = flashcards.count - 1
            print("Our current index is \(currentIndex)")
            
            //Update buttons
            updateNextPrevButtons()
            
            //Update labels
            updateLabels()
            
            btnOptionOne.setTitle(extraAnswerOne, for: .normal)
            btnOptionTwo.setTitle(answer, for: .normal)
            btnOptionThree.setTitle(extraAnswerTwo, for: .normal)
            
            //Save Flashcard
            saveAllFlashcardsToDisk()
        }
        }
    
    func updateNextPrevButtons() {
        
        //Disable next button if at the end
        if currentIndex == flashcards.count - 1 {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
        
        //Disable prev button if at the beginning
        if currentIndex == 0 {
            prevButton.isEnabled = false
        } else {
            prevButton.isEnabled = true
        }
    }
    
    func updateLabels() {
        
        //Get current flashcard
        let currentFlashcard = flashcards[currentIndex]
        
        //Update labels
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
        
        //Update buttons
        let buttons = [btnOptionOne, btnOptionTwo, btnOptionThree].shuffled()
        let answers = [currentFlashcard.answer, currentFlashcard.extraAnswerOne, currentFlashcard.extraAnswerTwo].shuffled()
        
        for (button, answer) in zip(buttons, answers) {
            //Set the title of this random button, with a random answer
            button?.setTitle(answer, for: .normal)
            
            //If this is the correct answer, save the button
            if answer == currentFlashcard.answer {
                correctAnswerButton = button
            }
        }
        
    }
    
    func saveAllFlashcardsToDisk() {
        
        //From flashcard array to dictionary array
        let dictionaryArray = flashcards.map { (card) -> [String:String] in return ["question": card.question, "answer": card.answer, "extraAnswerOne": card.extraAnswerOne, "extraAnswerTwo": card.extraAnswerTwo]
        }
        
        //Save array on disk using UserDefaults
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        
        //Log it
        print("Flashcards saved to UserDefaults")
        
    }
    
    func readSavedFlashcards(){

        //Read dictionary array from disk (if any)
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]] {

            //In here we know for sure we have a dictionary array
            let savedCards = dictionaryArray.map { dictionary -> Flashcard in return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!, extraAnswerOne: dictionary["extraAnswerOne"]!, extraAnswerTwo: dictionary["extraAnswerTwo"]!)
            }
            //Put all these cards in our flashcards array
            flashcards.append(contentsOf: savedCards)

        }

    }

}
