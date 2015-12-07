import UIKit

class CheckedCell: UITableViewCell {
  
  lazy var formatter = NSDateFormatter()
  override func awakeFromNib() {
    print("awakefromNib")
  }
  
  func configureCell(item: ChecklistItem) {
    let textFont = UIFont(name: "DFWaWaSC-W5", size: 17.0)
    let detailFont = UIFont(name: "DFWaWaSC-W5", size: 12.0)
    if let font = textFont {
      let textAttributes = [NSFontAttributeName:font]
      let string = NSMutableAttributedString(string: item.text, attributes:textAttributes)
     
      string.addAttribute(NSStrikethroughStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(0, string.length))
      
      self.textLabel?.attributedText = string
      
    }
    
    if let font = detailFont {
 
      formatter.dateStyle = NSDateFormatterStyle.MediumStyle
      formatter.timeStyle = NSDateFormatterStyle.ShortStyle
      let enLocale = NSLocale(localeIdentifier: "en_GB")
      formatter.locale = enLocale
      
      self.detailTextLabel?.font = font
      self.detailTextLabel?.textColor = UIColor.blackColor()
      self.detailTextLabel?.alpha = 0.5
      self.detailTextLabel?.text = formatter.stringFromDate(item.completionDate)
      
    }

  }
}
