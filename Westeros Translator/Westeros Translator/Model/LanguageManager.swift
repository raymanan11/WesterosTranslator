//
//  LanguageManager.swift
//  Westeros Translator
//
//  Created by Raymond An on 4/5/20.
//  Copyright © 2020 Raymond An. All rights reserved.
//

import Foundation

protocol LanguageDelegate {
    func updateUI(_ info: LanguageInfo)
    func error()
}

struct LanguageManager {
    var delegate: LanguageDelegate?
    
    let languages:[String] = ["Dothraki", "Valyrian"];
    
    let apiURL = "https://api.funtranslations.com/translate/"
    let apiURL2 = ".json?text="
    
    func handleUserInput(_ phrase: String, _ language: String) {
        let lowercasedLanguage = language.lowercased()
        var userPhrase = phrase.replacingOccurrences(of: " ", with: "%20")
        userPhrase = userPhrase.replacingOccurrences(of: "’", with: "%27")
        userPhrase = userPhrase.replacingOccurrences(of: ".", with: ".%20")
        userPhrase = userPhrase.replacingOccurrences(of: ",", with: ",%20")
        print(userPhrase)
        let fullURL = "\(apiURL)\(lowercasedLanguage)\(apiURL2)\(userPhrase)"
        apiCall(fullURL);
    }
    
    func apiCall(_ url: String) {
        if let url = URL(string: url) {
            let urlSession = URLSession(configuration: .default)
            let accessInfo = urlSession.dataTask(with: url, completionHandler: handle(data:urlResponse:error:))
            accessInfo.resume()
        }
    }
    
    func handle(data: Data?, urlResponse: URLResponse?, error: Error?) {
        if error != nil {
            delegate?.error()
            return
        }
        else {
            if let correctData = data {
                if let info = accessInfo(correctData) {
                    delegate?.updateUI(info)
                }
            }
        }
    }
    
    func accessInfo(_ data: Data) -> LanguageInfo? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(LanguageDecoder.self, from: data)
            var languageInfo = LanguageInfo();
            languageInfo.translated = decodedData.contents.translated!
            languageInfo.text = decodedData.contents.text!
            return languageInfo;
        }
        catch {
            delegate?.error()
            return nil;
        }
    }
}
