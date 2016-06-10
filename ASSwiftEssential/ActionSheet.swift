
import Foundation
import UIKit

/*
 [UIViewController]
 
 class BaseController : UIViewController, ActionSheetDelegate {
   func actionSheetSelected(tag:Int, buttonAtIndex:Int) {
     Log.d("\(tag), \(buttonAtIndex)")
   }
 }
 
 [表示方法1]
 let sheet = ActionSheet.init(title: "title", items: ["1", "2", "3"], delegate: self)
 sheet.show()
 
 [表示方法2]
 let sheet = ActionSheet()
 sheet.title = "title"
 sheet.items = ["1", "2", "3"]
 sheet.cancelIndex = 2
 sheet.destructiveIndex = -1
 sheet.tag = 10
 sheet.delegate = self
 sheet.arrowDirection = UIPopoverArrowDirection.Down
 sheet.show()
 
 [iPadでの表示]
 UIBarButtonItemからの吹き出し表示
 sheet.showFromBarButton(self.navigationItem.rightBarButtonItem!)

 UIButtonなどのViewからの吹き出し表示
 sheet.showFromRect(btn.bounds, inView: btn)
*/


protocol ActionSheetDelegate {
    func actionSheetSelected(tag:Int, buttonAtIndex:Int)
}

class ActionSheet {
    static let notificationName = "DissMissActionController"
    
    var alert : UIAlertController?
    var delegate : ActionSheetDelegate!
    var title = ""
    var items = []
    var destructiveIndex = -1
    var cancelIndex = -1
    var tag = -1
    var arrowDirection = UIPopoverArrowDirection.Any

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    init() {
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(dismiss),
                                                         name: ActionSheet.notificationName,
                                                         object: nil)
    }

    convenience init(title: String,
                     items: NSArray,
                     delegate: ActionSheetDelegate) {
        self.init()
        self.title = title
        self.items = items
        self.cancelIndex = items.count-1
        self.delegate = delegate
    }

    convenience init(title: String,
                     items: NSArray,
                     delegate: ActionSheetDelegate,
                     cancelIndex: Int,
                     destructiveIndex: Int,
                     tag: Int,
                     direction: UIPopoverArrowDirection) {
        self.init()
        self.title = title
        self.items = items
        self.cancelIndex = cancelIndex
        self.destructiveIndex = destructiveIndex
        self.delegate = delegate
        self.tag = tag
        self.arrowDirection = direction
    }

    // 現在開いている全てのAlertControllerを閉じる
    static func dismiss() {
        let notification = NSNotification.init(name: ActionSheet.notificationName, object: nil)
        NSNotificationCenter.defaultCenter().postNotification(notification)
    }
    
    @objc func dismiss() {
        if(self.alert != nil){
            self.alert!.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    // iPhone : 通常のActionSheet
    // iPad : 画面中央に表示
    func show() {
        let vc = self.delegate as! UIViewController
        
        let alert = self.createAlert()
        alert.popoverPresentationController?.sourceView = vc.view
        alert.popoverPresentationController?.sourceRect = vc.view.bounds
        alert.popoverPresentationController?.permittedArrowDirections = []
        
        vc.presentViewController(alert, animated: true, completion: nil)
        self.alert = alert
    }
    
    // iPhone : 通常のActionSheet
    // iPad : 指定したBarButtonから吹き出しで表示
    func showFromBarButton(sender: AnyObject?) {
        let vc = self.delegate as! UIViewController

        let alert = self.createAlert()
        alert.popoverPresentationController?.sourceView = vc.view
        alert.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
        
        if(self.arrowDirection != UIPopoverArrowDirection.Any){
            alert.popoverPresentationController?.permittedArrowDirections = self.arrowDirection
        }

        vc.presentViewController(alert, animated: true, completion: nil)
        self.alert = alert
    }
    
    // iPhone : 通常のActionSheet
    // iPad : 指定した位置から吹き出しで表示（UIButtonなどからで利用）
    func showFromRect(rect: CGRect, inView view: UIView) {
        let vc = self.delegate as! UIViewController

        let alert = self.createAlert()
        alert.popoverPresentationController?.sourceView = view
        alert.popoverPresentationController?.sourceRect = rect

        if(self.arrowDirection != UIPopoverArrowDirection.Any){
            alert.popoverPresentationController?.permittedArrowDirections = self.arrowDirection
        }
        
        vc.presentViewController(alert, animated: true, completion: nil)
        self.alert = alert
    }

    private func createAlert() -> UIAlertController {
        let alert = UIAlertController.init(title: nil, message: self.title, preferredStyle: UIAlertControllerStyle.ActionSheet)

        for i in 0 ..< self.items.count {
            let title = self.items[i] as! String

            var style = UIAlertActionStyle.Default
            if(i == self.destructiveIndex){
                style = UIAlertActionStyle.Destructive
            }else if(i == self.cancelIndex){
                style = UIAlertActionStyle.Cancel
            }
            
            alert.addAction(UIAlertAction.init(title: title, style: style, handler: { action in
                self.delegate.actionSheetSelected(self.tag, buttonAtIndex: i)
            }))
        }
        return alert
    }
}
