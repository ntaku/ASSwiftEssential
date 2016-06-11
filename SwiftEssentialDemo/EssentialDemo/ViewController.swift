
import UIKit

class ViewController: UIViewController {
    
    var v1: UIView!
    var v2: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        createNavibar()
        
        // Device
        Logger.d("ios ver = \(Device.iOSVersion())")
        Logger.d("app ver = \(Device.appVersion())")
        
        // ExtString
        let n = "test test".length()
        Logger.d("\(n)")

        // ExtColor
        let color1 = UIColor.color(0x66C8F8)
        let color2 = UIColor.colorString("0xEBEBEC")
        Logger.d(color1.toString()!)
        Logger.d(color2.toRGBA().debugDescription)

        // Sample view
        let w = CGRectGetWidth(self.view.bounds)

        v1 = UIView.init(frame: CGRectMake(0, 0, w, 50))
        v1.backgroundColor = color1
        self.view.addSubview(v1)

        v2 = UIView.init(frame: CGRectMake(0, 50, w, 50))
        v2.backgroundColor = color2
        self.view.addSubview(v2)
        
        // ExtImage
        /*
        var img = UIImage.init(named: "orientation_6.jpg")!

        let iw = CGRectGetWidth(self.view.bounds)
        let ih = CGRectGetHeight(self.view.bounds)
        let size = CGSizeMake(iw*2, ih*2)

        Logger.d(img.orientationString())
        img = img.resize(size, quality: .High, contentMode: .ScaleAspectFit)
        img = img.crop()
        Logger.d(img.orientationString())
        Logger.d(img.description)
        
        let imageView = UIImageView.init(frame: self.view.bounds)
        imageView.backgroundColor = UIColor.grayColor()
        imageView.contentMode = .ScaleAspectFit
        imageView.image = img
        self.view.addSubview(imageView)
         */
    }
    
    @objc func actionLeft() {

        // ExtView
        self.view.removeAllSubViews()
    }

    @objc func actionRight() {

        // ExtView
        if self.view.hasView(v1) {
            Logger.d("v1 is subview of self.view")
        }
        if v1.isSubviewOf(self.view) {
            Logger.d("v1 is subview of self.view")
        }
        
        v1.setX(100)
        v1.setY(100)
        v1.setW(100)
        v1.setH(100)
    }

    func createNavibar() {
        self.navigationController?.navigationBar.translucent = false
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "action",
                                                                     style: .Plain,
                                                                     target: self,
                                                                     action: #selector(actionLeft))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "action",
                                                                      style: .Plain,
                                                                      target: self,
                                                                      action: #selector(actionRight))
    }
}