//
//  ViewController.swift
//  Westeros Translator
//
//  Created by Raymond An on 4/5/20.
//  Copyright © 2020 Raymond An. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var pickerView = UIPickerView()
    var languageManager = LanguageManager()
    var language: String = ""

    @IBOutlet weak var phraseToBeTranslated: UITextField!
    
    @IBOutlet weak var gotLanguage: UITextField!
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        phraseToBeTranslated.endEditing(true)
        if gotLanguage.text != "", let phrase = phraseToBeTranslated.text {
            languageManager.handleUserInput(phrase, language)
        }
        else {
            phraseToBeTranslated.placeholder = "Please type a phrase to be translated"
            gotLanguage.placeholder = "Please choose a language"
        }
    }
    @IBOutlet weak var englishPhrase: UILabel!
    
    @IBOutlet weak var gotLanguagePhrase: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gotLanguage.inputView = pickerView
        gotLanguage.textAlignment = .center;
        gotLanguage.placeholder = "Select Language"
        
        pickerView.dataSource = self;
        pickerView.delegate = self;
        phraseToBeTranslated.delegate = self;
        languageManager.delegate = self
        // Do any additional setup after loading the view.
    }
}

// MARK: - UIPickerViewDataSource

extension ViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languageManager.languages.count;
    }
}

// MARK: - UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languageManager.languages[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        language = languageManager.languages[row]
        gotLanguage.text = languageManager.languages[row]
        gotLanguagePhrase.text = languageManager.languages[row]
        gotLanguage.resignFirstResponder()
    }
}

// MARK: - UITextFieldDelegate

extension ViewController: UITextFieldDelegate {
    
    // press the return button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(phraseToBeTranslated.text != "") {
            phraseToBeTranslated.endEditing(true)
            return true;
        }
        else {
            phraseToBeTranslated.placeholder = "Please type a phrase to be translated"
            return false;
        }
    }
    // press the search button or any other button
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if(phraseToBeTranslated.text != "") {
            return true;
        }
        else {
            phraseToBeTranslated.placeholder = "Please type a phrase to be translated"
            return false;
        }
    }
}

// MARK: - LanguageDelegate

extension ViewController: LanguageDelegate {
    func updateUI(_ info: LanguageInfo) {
        DispatchQueue.main.async {
            self.englishPhrase.text = info.text
            self.gotLanguagePhrase.text = info.translated
        }
    }
    
    func error() {
        print("Error occurred!")
    }
}
