//
//  LanguageDecoder.swift
//  Westeros Translator
//
//  Created by Raymond An on 4/6/20.
//  Copyright © 2020 Raymond An. All rights reserved.
//

import Foundation

struct LanguageDecoder: Decodable {
    var contents: Contents
}

struct Contents: Decodable {
    var translated: String?
    var text: String?
    var translation: String?
}
