//
//  CreationViewController.swift
//  Flashcards
//
//  Created by Christopher Crowley on 9/22/22.
//

import UIKit

class CreationViewController: UIViewController {

    var flashcardsController: ViewController!
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var extraAnswerOne: UITextField!
    @IBOutlet weak var extraAnswerTwo: UITextField!
    
    
    var initialQuestion: String?
    var initialAnswer: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        questionTextField.text = initialQuestion
        answerTextField.text = initialAnswer
    }
    
    @IBAction func didTapOnCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func didTapOnDone(_ sender: Any) {
       
        //Get the text in the question text field
        let questionText = questionTextField.text
        
        //Get the text in the answer text field
        let answerText = answerTextField.text
        
        //Get the texts in the extra answer text fields
        let extraAnswerOneText = extraAnswerOne.text
        
        let extraAnswerTwoText = extraAnswerTwo.text
        
        let alert = UIAlertController(title: "Missing text", message: "You need to enter both a question and an answer", preferredStyle: .alert)
       
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        
        //Check if empty
        if (questionText == nil || answerText == nil || questionText!.isEmpty || answerText!.isEmpty) {
            //show error
            present(alert, animated: true)
        }
        else {
            
            //See if it's existing
            var isExisting = false
            if initialQuestion != nil {
                isExisting = true
            }
            //Call the function to update the flashcard
            flashcardsController.updateFlashcard(question: questionText!, answer: answerText!, extraAnswerOne: extraAnswerOneText!, extraAnswerTwo: extraAnswerTwoText!, isExisting: isExisting)
        
            //Dismiss
            dismiss(animated: true)
        }
    }
        
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

