
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

        // ExtColor
        let color1 = UIColor.hex(0x66C8F8)
        let color2 = UIColor.hex(string: "0xEBEBEC")
        Logger.d(color1.toString()!)
        Logger.d(color2.toRGBA().debugDescription)

        // ExtString
        Logger.d("ひらがな".toKatakana())
        Logger.d("カタカナ".toHiragana())
        Logger.d("length = \("test test test".length)")
        Logger.d("test test test".split(by: " ").description)
        Logger.d("test test test".gsub(from: " ", to: ""))
        Logger.d("\("test test".boundingHeight(with: UIFont.systemFont(ofSize: 12), width: 30))")
        
        // Sample view
        let w = self.view.bounds.width

        v1 = UIView.init(frame: CGRect(x: 0, y: 0, width: w, height: 50))
        v1.backgroundColor = color1
        self.view.addSubview(v1)

        v2 = UIView.init(frame: CGRect(x: 0, y: 50, width: w, height: 50))
        v2.backgroundColor = color2
        self.view.addSubview(v2)
        
        // ExtImage
        /*
        var img = UIImage.init(named: "orientation_6.jpg")!

        let iw = self.view.bounds.width
        let ih = self.view.bounds.height
        let size = CGSize(width: iw*2, height: ih*2)

        Logger.d(img.orientationString())
        img = img.resize(size, quality: .high, contentMode: .scaleAspectFit)
        img = img.crop()
        Logger.d(img.orientationString())
        Logger.d(img.description)
        
        let imageView = UIImageView.init(frame: self.view.bounds)
        imageView.backgroundColor = UIColor.gray
        imageView.contentMode = .scaleAspectFit
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
        if self.view.has(view: v1) {
            Logger.d("v1 is subview of self.view")
        }
        if v1.isSubview(of: self.view) {
            Logger.d("v1 is subview of self.view")
        }
        
        v1.set(x: 100)
        v1.set(y: 100)
        v1.set(width: 100)
        v1.set(height: 100)
    }

    func createNavibar() {
        self.navigationController?.navigationBar.isTranslucent = false
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "action",
                                                                     style: .plain,
                                                                     target: self,
                                                                     action: #selector(actionLeft))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "action",
                                                                      style: .plain,
                                                                      target: self,
                                                                      action: #selector(actionRight))
    }
}
