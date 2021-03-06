import UIKit
import Foundation


class ChecklistsViewController: UIViewController,ItemDetailViewControllerDelegate,UITableViewDataSource,UITableViewDelegate {
    

    
  @IBOutlet var tableView: UITableView!
 

    var list: checklist!
  var checkedItems = [ChecklistItem]()
  var uncheckedItems = [ChecklistItem]()
  var label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = list.name
      tableView.separatorColor = view.tintColor
      tableView.tableFooterView = UIView()
      tableView.sectionIndexBackgroundColor = view.tintColor
      tableView.rowHeight = 50
      tableView.separatorInset = UIEdgeInsets(top: 0,left: 25,bottom: 0,right: 0)
      
      for item in list.items as [ChecklistItem] {
        if item.checked == true {
          checkedItems.append(item)
        } else {
          uncheckedItems.append(item)
        }
      }
      let cellNib = UINib(nibName: "CheckedCell", bundle: nil)
      tableView.registerNib(cellNib, forCellReuseIdentifier: "CheckedCell")
      
      setupFooterLabel()
      updateFooterLabel()
     
// Do any additional setup after loading the view, typically from a nib.
    }
  
// setup footer label
  
  func setupFooterLabel() {
    label.frame = CGRectMake(0, view.frame.size.height / 2, view.frame.size.width,50)
    tableView.tableFooterView?.addSubview(label)
    label.textAlignment = .Center
    label.textColor = view.tintColor
    let font = UIFont(name: "DFWaWaSC-W5", size: 19.0)
    label.font = font!
    
  }
// make the lable dynamic
  func updateFooterLabel() {
    
    
    if checkedItems.count == 0 && uncheckedItems.count == 0{
      label.frame = CGRectMake(0, view.frame.size.height / 2, view.frame.size.width,50)
      label.text = "Please add some events"
    } else if checkedItems.count == 0 {
      
      label.frame.origin = CGPoint.zero
      
      label.text = "\(uncheckedItems.count) events are unfinished！"
      
    } else if uncheckedItems.count == 0 {
      label.frame.origin = CGPoint.zero
      label.text = "All finished！！"
    } else {
      label.frame.origin = CGPoint.zero
      label.text = "\(uncheckedItems.count) events are unfinished!"
      
    }
  }

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return list.items.count - list.checkedNum
    } else {
      return list.checkedNum
    }
    
  }
  

  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 2
  }
  
  func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    if section == 0 {
      return "Unfinished"
    } else {
      return "Finished"
    }
  }
  
  func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
   
    let labelRect = CGRect(x: 15, y: tableView.sectionHeaderHeight - 20, width: 300, height: 14)
    
    let label = UILabel(frame: labelRect)
    
    let font = UIFont(name: "DFWaWaSC-W5", size: 17.0)
    let attributedString : NSMutableAttributedString = NSMutableAttributedString(string: tableView.dataSource!.tableView!(tableView,titleForHeaderInSection: section)!)
 
    attributedString.addAttribute(NSFontAttributeName, value: font!, range: NSMakeRange(0, attributedString.length))
    attributedString.addAttribute(NSStrokeWidthAttributeName, value: NSNumber(float: -3.0), range: NSMakeRange(0, attributedString.length))
    attributedString.addAttribute(NSStrokeColorAttributeName, value: self.view.tintColor, range: NSMakeRange(0, attributedString.length))
    
    label.attributedText = attributedString
    label.textColor = self.view.tintColor
    label.backgroundColor = UIColor.clearColor()
    
    let separatorRect = CGRect(x: 15, y: tableView.sectionHeaderHeight - 5, width: tableView.bounds.size.width - 15, height: 2)
    let separator = UIView(frame: separatorRect)
    separator.backgroundColor = tableView.separatorColor
    
    let viewRect = CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.sectionHeaderHeight)
    let view = UIView(frame: viewRect)
    view.backgroundColor = UIColor.whiteColor()
    view.addSubview(label)
    view.addSubview(separator)
    
    return view
  }

 
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    
    
    if indexPath.section == 0 {
      let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem")
        
      let clockView = UIImageView(frame: CGRectMake(2, 15, 20, 20))
      clockView.image = UIImage(named: "Appointments")
      cell!.addSubview(clockView)
      let item = uncheckedItems[indexPath.row]
      clockView.tag = 100
      clockView.hidden = !item.shouldRemind
      
      let image = UIImage(named: "edit")
      let button = UIButton(type: .Custom);
        
        
      let frame = CGRectMake(44.0, 44.0, image!.size.width, image!.size.height)
      button.frame = frame
      button.setBackgroundImage(image, forState: .Normal)
      
      
      
      button.backgroundColor = UIColor.clearColor()
      button.addTarget(self, action: Selector("accessoryTapped:event:"), forControlEvents: UIControlEvents.TouchUpInside)
      cell!.accessoryView = button
      
      
  
      
      configureTextForCell(cell!, withChecklistItem: item)
      updateFooterLabel()
      
      return cell!
      
      
    } else {
      let cell = tableView.dequeueReusableCellWithIdentifier("CheckedCell", forIndexPath: indexPath) as! CheckedCell
      let item = checkedItems[indexPath.row]
      cell.configureCell(item)
      cell.textLabel?.textColor = view.tintColor
      updateFooterLabel()
      return cell

      
    }

    


  }
  
  func accessoryTapped(sender: AnyObject,event: AnyObject) {
    let touches = event.allTouches()
    
    let a = touches?.first
    let touch = a
    let currentTouchPosion = touch!.locationInView(tableView)
    let indexPath = tableView.indexPathForRowAtPoint(currentTouchPosion)
    if indexPath !=  nil {
      performSegueWithIdentifier("EditItem", sender: tableView.cellForRowAtIndexPath(indexPath!))
    }
    
  }

    
  func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    var item = ChecklistItem()
    if indexPath.section == 0 {
      item = uncheckedItems[indexPath.row]
      uncheckedItems.removeAtIndex(indexPath.row)
    } else if indexPath.section == 1 {
      item = checkedItems[indexPath.row]
      checkedItems.removeAtIndex(indexPath.row)
    }
    
    if let index = list.items.indexOf(item) {
      list.items.removeAtIndex(index)
    }
    
    
      
    let indexPaths = [indexPath]
    tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    updateFooterLabel()
        
  }
    
    
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
    var item = ChecklistItem()
    if indexPath.section == 0 {
      item = uncheckedItems[indexPath.row]
      item.toggleChecked()
      item.completionDate = NSDate()
      uncheckedItems.removeAtIndex(indexPath.row)
      checkedItems.append(item)
  
    } else {
      item = checkedItems[indexPath.row]
      item.toggleChecked()
      checkedItems.removeAtIndex(indexPath.row)
      uncheckedItems.append(item)
      item.shouldRemind = false
    }
    
    tableView.reloadData()
  
    
        
    
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
        

    }
     

    
    func configureTextForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        let font = UIFont(name: "DFWaWaSC-W5", size: 19.0)
        if let font = font {
          let attributes = [NSFontAttributeName:font]
          let string = NSMutableAttributedString(string: item.text, attributes:attributes)
          
          label.attributedText = string
        
        
        }
      
      
      
      
        label.textColor = view.tintColor
    }

    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
        let newRowIndex = uncheckedItems.count
        uncheckedItems.append(item)
        list.items.append(item)
        
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
        updateFooterLabel()
        
        dismissViewControllerAnimated(true , completion: nil)
       
    }
    
    func itemDetailViewController(controller : ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
      
      if let index = uncheckedItems.indexOf(item) {
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
          configureTextForCell(cell, withChecklistItem: item)
          cell.viewWithTag(100)?.hidden = !item.shouldRemind
        } else if let index = checkedItems.indexOf(item) {
          let indexPath = NSIndexPath(forRow: index, inSection: 1)
          if let cell = tableView.cellForRowAtIndexPath(indexPath) as? CheckedCell {
            cell.configureCell(item)

          }
        }
        
      }
      
      

      dismissViewControllerAnimated(true , completion: nil)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "AddItem" {
            let navigationcontroller = segue.destinationViewController as! UINavigationController
            let controller = navigationcontroller.topViewController as! ItemDetailViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let navigationcontroller = segue.destinationViewController as! UINavigationController
            let controller = navigationcontroller.topViewController as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
              if indexPath.section == 0 {
                controller.ItemToEdit = uncheckedItems[indexPath.row]
              } else if indexPath.section == 1{
                controller.ItemToEdit = checkedItems[indexPath.row]
              }
            }
           
            
        }
    }
 


}
	
