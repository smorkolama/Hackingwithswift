import UIKit

let name = "Taylor"

for letter in name {
    print("Give me a \(letter)")
}

//print(name[3])
let letter = name[name.index(name.startIndex, offsetBy: 3)]

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

let password = "123456"
password.hasPrefix("123")
password.hasSuffix("456")

extension String {
    // remove a prefix if it exists
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }

    // remove a suffix if it exists
    func deletingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
}

password.deletingPrefix("123")
password

let weather = "it's going to rain"
weather.lowercased()
weather.uppercased()
weather.capitalized

extension String {
    var capitalizedFirst: String {
        guard let firstLetter = self.first else { return "" }
        return firstLetter.uppercased() + self.dropFirst()
    }
}

weather.capitalizedFirst

let input = "Swift is like Objective-C without the C"
input.contains("Swift")

let languages = ["Python", "Ruby", "Swift"]
languages.contains("Swift")

// contains(where:) calls close for every element in languages until true is returned
// input.contains is passed as closure like input.contains("Python") etc
languages.contains(where: input.contains)


// NSAttributedString

let string = "This is a test string"
let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white,
                                                 .backgroundColor: UIColor.red,
                                                 .font: UIFont.boldSystemFont(ofSize: 36)]
let attributedString = NSMutableAttributedString(string: string, attributes: attributes)

// You could do the above with UILabel but that works only for the entire string

attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 8), range: NSRange(location: 0, length: 4))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 5, length: 2))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 24), range: NSRange(location: 8, length: 2))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 32), range: NSRange(location: 10, length: 4))
attributedString.addAttribute(.underlineStyle, value: NSUnderlineStyle.double.rawValue, range: NSRange(location: 15, length: 6))
attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 40), range: NSRange(location: 15, length: 6))

attributedString.addAttribute(.link, value: "http://www.smork.info", range: NSRange(location: 0, length: 4))

let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 75))
label.attributedText = attributedString
