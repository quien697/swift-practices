//
//  QuestionViewController.swift
//  PersonalityQuiz
//
//  Created by Quien on 2022/11/21.
//

import UIKit

class QuestionViewController: UIViewController {
  
  @IBOutlet weak var questionLabel: UILabel!
  
  @IBOutlet weak var singleStackView: UIStackView!
  @IBOutlet weak var singleButton1: UIButton!
  @IBOutlet weak var singleButton2: UIButton!
  @IBOutlet weak var singleButton3: UIButton!
  @IBOutlet weak var singleButton4: UIButton!
  
  @IBOutlet weak var mutipleStackView: UIStackView!
  @IBOutlet weak var mutipleLabel1: UILabel!
  @IBOutlet weak var mutipleLabel2: UILabel!
  @IBOutlet weak var mutipleLabel3: UILabel!
  @IBOutlet weak var mutipleLabel4: UILabel!
  @IBOutlet weak var mutipleSwitch1: UISwitch!
  @IBOutlet weak var mutipleSwitch2: UISwitch!
  @IBOutlet weak var mutipleSwitch3: UISwitch!
  @IBOutlet weak var mutipleSwitch4: UISwitch!
  
  @IBOutlet weak var rangedStackView: UIStackView!
  @IBOutlet weak var rangedLabel1: UILabel!
  @IBOutlet weak var rangedLabel2: UILabel!
  @IBOutlet weak var rangedSlider: UISlider!
  
  @IBOutlet weak var questionProgressView: UIProgressView!
  
  var questions: [Question] = [
    Question(
      text: "Which food do you like the most?",
      type: .single,
      answers: [
        Answer(text: "Steak", type: .dog),
        Answer(text: "Fish", type: .cat),
        Answer(text: "Carrots", type: .rabbit),
        Answer(text: "Corn", type: .turtle)
      ]
    ),
    Question(
      text: "Which activities do you enjoy?",
      type: .multiple,
      answers: [
        Answer(text: "Swimming", type: .turtle),
        Answer(text: "Sleeping", type: .cat),
        Answer(text: "Cuddling", type: .rabbit),
        Answer(text: "Eating", type: .dog)
      ]
    ),
    Question(
      text: "How much do you enjoy car rides?",
      type: .ranged,
      answers: [
        Answer(text: "I dislike them", type: .cat),
        Answer(text: "I get a little nervous", type: .rabbit),
        Answer(text: "I barely notice them", type: .turtle),
        Answer(text: "I love them", type: .dog)
      ]
    )
  ]
  
  var questionIndex = 0
  var answersChosen: [Answer] = []

  override func viewDidLoad() {
    super.viewDidLoad()
    updateUI()
  }
  
  @IBAction func singleAnswerButtonPresswed(_ sender: UIButton) {
    let currentAnswers = questions[questionIndex].answers
    
    switch sender {
    case singleButton1:
      answersChosen.append(currentAnswers[0])
    case singleButton2:
      answersChosen.append(currentAnswers[1])
    case singleButton3:
      answersChosen.append(currentAnswers[2])
    case singleButton4:
      answersChosen.append(currentAnswers[3])
    default:
      break
    }
    nextQuestion()
  }
  
  @IBAction func mutipleAnswerButtonPressed(_ sender: UIButton) {
    let currentAnswers = questions[questionIndex].answers
    
    if mutipleSwitch1.isOn {
      answersChosen.append(currentAnswers[0])
    }
    if mutipleSwitch2.isOn {
      answersChosen.append(currentAnswers[1])
    }
    if mutipleSwitch3.isOn {
      answersChosen.append(currentAnswers[2])
    }
    if mutipleSwitch4.isOn {
      answersChosen.append(currentAnswers[3])
    }
    nextQuestion()
  }
  
  @IBAction func rangedAnswerButtonPressed(_ sender: UIButton) {
    let currentAnswers = questions[questionIndex].answers
    let index = Int(round(rangedSlider.value) * Float(currentAnswers.count-1))
    answersChosen.append(currentAnswers[index])
    nextQuestion()
  }
  
  @IBSegueAction func showResults(_ coder: NSCoder) -> UIViewController? {
    return ResultsViewController(coder: coder, responses: answersChosen)
  }
  
  func updateUI() {
    singleStackView.isHidden = true
    mutipleStackView.isHidden = true
    rangedStackView.isHidden = true
    
    let currentQuestion = questions[questionIndex]
    let currentAnswers = currentQuestion.answers
    let totalProgress = Float(questionIndex) / Float(questions.count)
    
    navigationItem.title = "Question #\(questionIndex + 1 )"
    questionLabel.text = currentQuestion.text
    questionProgressView.setProgress(totalProgress, animated: true)
    
    
    switch currentQuestion.type {
    case .single:
      updateSingelStack(using: currentAnswers)
    case .multiple:
      updateMultipleStack(using: currentAnswers)
    case .ranged:
      updateRangedStack(using: currentAnswers)
    }
  }
  
  func updateSingelStack(using answers: [Answer]) {
    singleStackView.isHidden = false
    singleButton1.setTitle(answers[0].text, for: .normal)
    singleButton2.setTitle(answers[1].text, for: .normal)
    singleButton3.setTitle(answers[2].text, for: .normal)
    singleButton4.setTitle(answers[3].text, for: .normal)
  }
  
  func updateMultipleStack(using answers: [Answer]) {
    mutipleStackView.isHidden = false
    mutipleLabel1.text = answers[0].text
    mutipleLabel2.text = answers[1].text
    mutipleLabel3.text = answers[2].text
    mutipleLabel4.text = answers[3].text
    mutipleSwitch1.isOn = false
    mutipleSwitch2.isOn = false
    mutipleSwitch3.isOn = false
    mutipleSwitch4.isOn = false
  }
  
  func updateRangedStack(using answers: [Answer]) {
    rangedStackView.isHidden = false
    rangedLabel1.text = answers.first?.text
    rangedLabel2.text = answers.last?.text
    rangedSlider.setValue(0.5, animated: false)
  }
  
  func nextQuestion() {
    questionIndex += 1
    if questionIndex < questions.count {
      updateUI()
    } else {
      performSegue(withIdentifier: "Results", sender: nil)
    }
  }
  
}
