import Foundation
import UIKit

public extension UIImage {

    /**
     中心を正方形にクロップする  (Exifの画像の向きは考慮されない)
     */
    @objc func crop() -> UIImage {
        let w = self.size.width
        let h = self.size.height
        let size = (w < h) ? w : h

        let sx = self.size.width/2 - size/2
        let sy = self.size.height/2 - size/2
        let rect = CGRect(x: sx, y: sy, width: size, height: size)
        return crop(bounds: rect)
    }

    /**
     指定した位置をクロップする  (Exifの画像の向きは考慮されない)
     */
    @objc func crop(bounds: CGRect) -> UIImage {
        let cgImage = self.cgImage?.cropping(to: bounds)
        return UIImage(cgImage: cgImage!)
    }

    /**
     長辺が指定したサイズになるように自動リサイズする
     */
    @objc func autoResize(_ maxsize: CGFloat) -> UIImage {
        if(maxsize > 0){
            let ratio = maxsize / max(self.size.width, self.size.height)
            let size = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)
            // オリジナルが指定サイズより小さい場合
            //（resizeを実行しておかないとExifの向きが上向きに修正されないので実行される場合と挙動が異なってしまう。）
            if self.size.width <= size.width && self.size.height <= size.height {
                return resize(self.size)
            }
            return resize(size)
        }
        return resize(self.size)
    }

    /**
     指定サイズでリサイズする  (Exifの画像の向きが上に修正される)
     */
    @objc func resize(_ size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size, format: imageRendererFormat).image { (context) in
            draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
    }

    @objc func orientationString() -> String {
        switch self.imageOrientation {
        case .up:               return "Up"
        case .down:             return "Down"
        case .left:             return "Left"
        case .right:            return "Right"
        case .upMirrored:       return "UpMirrored"
        case .downMirrored:     return "DownMirrored"
        case .leftMirrored:     return "LeftMirrored"
        case .rightMirrored:    return "RightMirrored"
        @unknown default:
            return "Unknown"
        }
    }

    /**
     JPGに変換する
     */
    @objc func toJpeg(_ quality: CGFloat) -> Data? {
        return self.jpegData(compressionQuality: quality)
    }

    /**
     PNGに変換する
     */
    @objc func toPng() -> Data? {
        return self.pngData()
    }

    /**
     指定色の画像を生成する
     */
    @objc class func image(from color: UIColor) -> UIImage {
        return image(from: color, size: CGSize(width: 1, height: 1))
    }

    //TODO UIGraphicsImageRendererにリプレイス
    /**
     指定色/サイズの画像を生成する
     */
    @objc class func image(from color: UIColor, size: CGSize) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: size.width, height: size.height), false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }

    //TODO UIGraphicsImageRendererにリプレイス
    /**
     指定色の画像に変換する
     */
    @objc func maskWith(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)

        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.setBlendMode(.normal)

        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.clip(to: rect, mask: cgImage!)

        color.setFill()
        context.fill(rect)

        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
}

