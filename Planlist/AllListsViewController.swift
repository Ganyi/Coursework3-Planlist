import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate,UINavigationControllerDelegate {


  
    var dataModel:DataModel!
    var label = UILabel()

  

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        tableView.separatorColor = view.tintColor
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.rowHeight = 50
      
      
        
        let index = dataModel.indexOfSelectedChecklit
        
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegueWithIdentifier("ShowChecklist", sender: checklist)
        }
      setupFooterLabel()
      updateFooterLabel()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
  
  func updateFooterLabel() {

    
    if dataModel.lists.count == 0 {
      label.frame = CGRectMake(0, view.frame.size.height / 2, view.frame.size.width,50)
      label.text = "Please add some items"
    } else {
      
      label.frame.origin = CGPoint.zero

      label.text = "\(self.dataModel.lists.count) items"

    }
  }
	
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellidentifier = "Cell"
        var cell : UITableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellidentifier)
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: cellidentifier)
            
        }
      
      let image = UIImage(named: "edit")
      let button = UIButton(type: UIButtonType.Custom)
      let frame = CGRectMake(44.0, 44.0, image!.size.width, image!.size.height)
      button.frame = frame
      button.setBackgroundImage(image, forState: .Normal)

      
      
      button.backgroundColor = UIColor.clearColor()
      button.addTarget(self, action: Selector("accessoryTapped:event:"), forControlEvents: UIControlEvents.TouchUpInside)
      cell.accessoryView = button
        
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel?.text = checklist.name
        cell.accessoryType = UITableViewCellAccessoryType.DetailButton
        cell.textLabel?.font = UIFont(name: "DFWaWaSC-W5", size: 19.0)
        cell.detailTextLabel?.font = UIFont(name: "DFWaWaSC-W5", size: 11.0)
        cell.textLabel?.textColor = view.tintColor
        cell.detailTextLabel?.textColor = view.tintColor
       
        //Dynamic lable changes according to the rest events
        let count = checklist.countUncheckedItems()
        if checklist.items.count == 0 {
            cell.detailTextLabel!.text = "No event"
        } else if count == 0 {
            cell.detailTextLabel!.text = "Completely finished"
        } else {
            cell.detailTextLabel!.text = "\(count) events left"
        }
        
        cell.imageView?.image = UIImage(named: checklist.iconName)
        updateFooterLabel()
        
        
        return cell
    }
 //Tap events
  func accessoryTapped(sender: AnyObject,event: AnyObject) {
    let touches = event.allTouches()

    let a = touches?.first
    let touch = a!
    let currentTouchPosion = touch.locationInView(tableView)
    let indexPath = tableView.indexPathForRowAtPoint(currentTouchPosion)
    if indexPath !=  nil {
      tableView(tableView!, accessoryButtonTappedForRowWithIndexPath: indexPath!)
    }
    
  }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        dataModel.indexOfSelectedChecklit = indexPath.row
        
        let list = dataModel.lists[indexPath.row]
        performSegueWithIdentifier("ShowChecklist", sender: list)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowChecklist" {
            let vc = segue.destinationViewController as! ChecklistsViewController
            vc.list = sender as! checklist
        } else if segue.identifier == "AddChecklist" {
            let navigationcontroller = segue.destinationViewController as! UINavigationController
            let vc = navigationcontroller.topViewController as! ListDetailViewController
            vc.checklistToEdit = nil
            vc.delegate = self
        }
    }
    
    func listDetailViewControllerDidCancel(controller: ListDetailViewController) {
            dismissViewControllerAnimated(true , completion: nil)
    }
    
    func listDetailViewController(controller: ListDetailViewController, didFinishAddingChecklist cl: checklist) {
        
        dataModel.lists.append(cl)
        dataModel.sortChecklists()
        tableView.reloadData()
        dismissViewControllerAnimated(true , completion:nil)
        
    }
    
    
    func listDetailViewController (controller: ListDetailViewController, didFinishEditingChecklist cl: checklist) {
        dataModel.sortChecklists()
        tableView.reloadData()
        
        dismissViewControllerAnimated(true , completion: nil)
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        dataModel.lists.removeAtIndex(indexPath.row)
        
        let indexpaths = [indexPath]
        tableView.deleteRowsAtIndexPaths(indexpaths, withRowAnimation: UITableViewRowAnimation.Automatic)
      updateFooterLabel()
        
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let navigationController = storyboard!.instantiateViewControllerWithIdentifier("ListNC") as! UINavigationController
        let vc = navigationController.topViewController as! ListDetailViewController
        
        vc.delegate = self
        let checklist = dataModel.lists[indexPath.row]
        vc.checklistToEdit = checklist
        
        presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        if viewController === self {
            dataModel.indexOfSelectedChecklit = -1
        }
    }
    
    
    
}
