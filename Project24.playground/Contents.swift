import UIKit

/* Individual letters in strings aren’t instances of String, but are instead instances of Character – a dedicated type for holding single-letters of a string.

So, that uppercased() method is actually a method on Character rather than String. However, where things get really interesting is that Character.uppercased() actually returns a string, not an uppercased Character. The reason is simple: language is complicated, and although many languages have one-to-one mappings between lowercase and uppercase characters, some do not.

For example, in English “a” maps to “A”, “b” to “B”, and so on, but in German “ß” becomes “SS” when uppercased. “SS” is clearly two separate letters, so uppercased() has no choice but to return a string.*/

//To check wether a String starts or ends with a substring
let password = "12345"
password.hasPrefix("123")
password.hasSuffix("345")

//An extension method in String allows us to extend the way prefixing and suffixing works:
//The dropFirst and dropLast methods remove a certain number of letters from the string
extension String {
    // remove a prefix if it exists
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self } //return self so it just returns the same string
        return String(self.dropFirst(prefix.count))
    }
    
    // remove a suffix if it exists
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
}

//We know lowercased() and uppercased(), but theres another method that makes the first letter of each word a capital letter
let weather = "it's going to rain"
print(weather.capitalized)
//Or make it just the first letter of the string
extension String {
    var capitalizedFirst: String {
        guard let firstLetter = self.first else { return "" }
        return firstLetter.uppercased() + self.dropFirst()
    }
}

//Contains method returns true if it contains another string
let input = "Swift is like Objective-C without the C"
input.contains("Swift")
//or
let languages = ["Python", "Ruby", "Swift"]
languages.contains("Swift")


//NSAttributeString allows us to create a set of attributes that affect the whole string
let string = "This is a test string"
let attributes: [NSAttributedString.Key: Any] = [
    .foregroundColor: UIColor.white,
    .backgroundColor: UIColor.red,
    .font: UIFont.boldSystemFont(ofSize: 36)
]

//let attributedString = NSAttributedString(string: string, attributes: attributes)

//NNMutableAttributeString is an attributed string we can modify

let attributedString = NSMutableAttributedString(string: string)
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 1))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))
