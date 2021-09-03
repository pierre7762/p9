//
//  TranslateViewController.swift
//  LeBaluchon
//
//  Created by Pierre on 13/07/2021.
//

import UIKit

class TranslateViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var answerTextView: UITextView!
    @IBOutlet weak var choiceOfLanguageSegmented: UISegmentedControl!
    @IBOutlet weak var buttonTranslate: CustomButton!
    
    var text: String = ""
    var translater = Translater(sourceLanguage: .fr)
    let translaterService = TranslateService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextView(textV: textView)
        setupTextView(textV: answerTextView)
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tap)
        textView.delegate = self
        translater.sourcetext = textView.text
        answerTextView.text = translater.translatedText
    }
    
    func setupTextView(textV: UITextView) {
        textV.layer.borderColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        textV.layer.borderWidth = 3
        textV.layer.cornerRadius = 20
    }
    
    func textViewDidChange(_ textView: UITextView) {
        translater.sourcetext = textView.text
    }
    
    func getTranslation() {
        buttonTranslate.isEnabled = false
        translaterService.getTranslation (callback: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let translation):
                    print(translation.data.translations[0].translatedText)
                    self?.translater.translatedText = translation.data.translations[0].translatedText
                    self?.answerTextView.text = self!.translater.translatedText
                case .failure(let error):
                    print(error)
                }
                self?.buttonTranslate.isEnabled = true
            }
        }, textToTranslate: translater.sourcetext, languageTarget: translater.targetLanguageString)
    }

    
    @objc func closeKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func choiceOfLanguagePressed(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: translater.sourceLanguage = .fr
        case 1: translater.sourceLanguage = .en
        default:
            break
        }
        
    }
     
    @IBAction func translateButtonPressed(_ sender: CustomButton) {
        getTranslation()
    }
}