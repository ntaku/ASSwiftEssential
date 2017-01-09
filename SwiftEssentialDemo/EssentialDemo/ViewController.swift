
import UIKit

class ViewController: UIViewController {
    
    var v1: UIView!
    var v2: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "view削除",
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(actionLeft))
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "view変更",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(actionRight))
        extDevice()
        extString()
        extColor()
    }

    func extDevice() {
        Logger.d("ios ver = \(Device.iOSVersion())")
        Logger.d("app ver = \(Device.appVersion())")
    }

    func extString() {
        Logger.d("ひらがな".toKatakana())
        Logger.d("カタカナ".toHiragana())
        Logger.d("length = \("test test test".length)")
        Logger.d("test test test".split(by: " ").description)
        Logger.d("test test test".gsub(from: " ", to: ""))
        Logger.d("\("test test".boundingHeight(with: UIFont.systemFont(ofSize: 12), width: 30))")
    }

    func extImage() {
        var img = UIImage.init(named: "orientation_6.jpg")!

        let iw = view.bounds.width
        let ih = view.bounds.height
        let size = CGSize(width: iw*2, height: ih*2)

        Logger.d(img.orientationString())
        img = img.autoResize(size, contentMode: .scaleAspectFit)
        img = img.crop()
        Logger.d(img.orientationString())
        Logger.d(img.description)

        let imageView = UIImageView.init(frame: view.bounds)
        imageView.backgroundColor = UIColor.gray
        imageView.contentMode = .scaleAspectFit
        imageView.image = img
        view.addSubview(imageView)
    }

    @objc func actionLeft() {
        // ExtView
        view.removeAllSubViews()
    }

    @objc func actionRight() {
        // ExtView
        if view.has(view: v1) {
            Logger.d("v1 is subview of view")
        }
        if v1.isSubview(of: view) {
            Logger.d("v1 is subview of view")
        }
        v1.set(x: 100)
        v1.set(y: 100)
        v1.set(width: 100)
        v1.set(height: 100)
    }

    func extColor() {
        let color1 = UIColor.hex(0x66C8F8)
        let color2 = UIColor.hex(string: "0xEBEBEC")
        Logger.d(color1.toString()!)
        Logger.d(color2.toRGBA().debugDescription)

        let w = view.bounds.width

        v1 = UIView.init(frame: CGRect(x: 0, y: 0, width: w, height: 50))
        v1.backgroundColor = color1
        view.addSubview(v1)

        v2 = UIView.init(frame: CGRect(x: 0, y: 50, width: w, height: 50))
        v2.backgroundColor = color2
        view.addSubview(v2)
    }
}
