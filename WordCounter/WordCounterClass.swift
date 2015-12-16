//
//  WordCounterClass.swift
//  WordCounter
//
//  Created by Arefly on 7/8/2015.
//  Copyright (c) 2015 Arefly. All rights reserved.
//

import Foundation

class WordCounter {
    
    // MARK: - Noun var
    let wordSingular = NSLocalizedString("Global.Units.Word.Singular", comment: "word")
    let wordPlural = NSLocalizedString("Global.Units.Word.Plural", comment: "words")
    
    let charSingular = NSLocalizedString("Global.Units.Character.Singular", comment: "character")
    let charPlural = NSLocalizedString("Global.Units.Character.Plural", comment: "characters")
    
    let paraSingular = NSLocalizedString("Global.Units.Paragraph.Singular", comment: "paragraph")
    let paraPlural = NSLocalizedString("Global.Units.Paragraph.Plural", comment: "paragraphs")
    
    let sentenceSingular = NSLocalizedString("Global.Units.Sentence.Singular", comment: "sentence")
    let sentencePlural = NSLocalizedString("Global.Units.Sentence.Plural", comment: "sentences")
    
    // MARK: - Get string func
    func getWordCountString (s: String) -> String {
        let count = wordCount(s)
        
        let words = (count == 1) ? wordSingular : wordPlural
        let title = String.localizedStringWithFormat(NSLocalizedString("Global.Count.Text.Word", comment: "%1$@ %2$@"), String(count), words)
        
        return title
    }
    
    func getCharacterCountString (s: String) -> String {
        let count = characterCount(s)
        
        let words = (count == 1) ? charSingular : charPlural
        let title = String.localizedStringWithFormat(NSLocalizedString("Global.Count.Text.Character", comment: "%1$@ %2$@"), String(count), words)
        
        return title
    }
    
    func getParagraphCountString (s: String) -> String {
        let count = paragraphCount(s)
        
        let words = (count == 1) ? paraSingular : paraPlural
        let title = String.localizedStringWithFormat(NSLocalizedString("Global.Count.Text.Paragraph", comment: "%1$@ %2$@"), String(count), words)
        
        return title
    }
    
    func getSentenceCountString (s: String) -> String {
        let count = sentenceCount(s)
        
        let words = (count == 1) ? sentenceSingular : sentencePlural
        let title = String.localizedStringWithFormat(NSLocalizedString("Global.Count.Text.Sentence", comment: "%1$@ %2$@"), String(count), words)
        
        return title
    }
    
    
    // MARK: - Get count func
    func wordCount(s: String) -> Int {
        var counts = 0
        let lines = s.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        let joinedString = lines.joinWithSeparator(" ")
        let words = joinedString.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        let modifiedWords = words.filter({
            let s = $0 as String?
            if !(s != nil) { return false }
            if (s!).characters.count < 1 { return false }

            if(s!.containsChineseCharacters){
                var results = self.matchesForRegexInText("\\p{Han}", text: s!)
                var sArray: Array = Array((s!).characters)
                if(String(sArray[0]) != results[0]){
                    counts += 1
                }
                //println(sArray[count(sArray)-1])
                //println(results[count(results)-1])
                if(String(sArray[sArray.count-1]) != results[results.count-1]){
                    counts += 1
                }
                counts += results.count
                return false
            }
            
            return true
        })
        
        counts += modifiedWords.count
        
        return counts
    }
    
    func characterCount(s: String) -> Int {
        var characterCounts = 0
        let modifiedCharacter = Array(s.characters).filter({
            let s = String($0) as String?
            if !(s != nil) { return false }
            if (s!).characters.count < 1 { return false }
            if (s == "\n") { return false }
            if s! == " " { return false }
            return true
        })
        characterCounts = modifiedCharacter.count
        
        return characterCounts
    }
    
    func paragraphCount(s: String) -> Int {
        var paragraphCounts = 0
        let lines = s.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
        let modifiedLines = lines.filter({
            let s = $0 as String?
            if !(s != nil) { return false }
            if (s!).characters.count < 1 { return false }
            return true
        })
        paragraphCounts = modifiedLines.count
        return paragraphCounts
    }
    
    func sentenceCount(s: String) -> Int {
        var sentenceCounts = 0
        var sentencesArr = [String]()
        s.enumerateSubstringsInRange(s.startIndex..<s.endIndex, options: .BySentences) {
            substring, substringRange, enclosingRange, stop in
            sentencesArr.append(substring!)
        }
        let modifiedLines = sentencesArr.filter({
            let oS = ($0 as String?)!
            let s = oS.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: "\n "))
            
            if (s).characters.count < 1 { return false }
            
            return true
        })
        
        sentenceCounts = modifiedLines.count
        return sentenceCounts
    }
    
    // TODO: Count words without pountuation
    
    
    // MARK: - Related func
    /**
    Search `regex` in `text`
    
    - Parameter regex:  The regex.
    - Parameter text:   The text.
    
    - Returns: A new `[string]` with result.
    */
    private func matchesForRegexInText(regex: String!, text: String!) -> [String] {
        let regex = try! NSRegularExpression(pattern: regex,
            options: [])
        let nsString = text as NSString
        let results = regex.matchesInString(text, options: [], range: NSMakeRange(0, nsString.length)) 
        return results.map { nsString.substringWithRange($0.range)}
    }
}

extension String {
    var containsChineseCharacters: Bool {
        return self.rangeOfString("\\p{Han}", options: .RegularExpressionSearch) != nil
    }
}