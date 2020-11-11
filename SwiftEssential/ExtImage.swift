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
            if self.size.width <= size.width && self.size.height <= size.height {
                return self
            }
            return resize(size)
        }
        return self
    }

    /**
     アスペクト比を保ったまま自動リサイズする
     */
//    @objc func autoResize(_ size: CGSize, contentMode: UIView.ContentMode) -> UIImage {
//        let horizontalRatio = size.width / self.size.width
//        let verticalRatio = size.height / self.size.height
//        let ratio: CGFloat
//
//        switch contentMode {
//        case .scaleAspectFit:
//            ratio = min(horizontalRatio, verticalRatio)
//            break
//        case .scaleAspectFill: fallthrough
//        default:
//            ratio = max(horizontalRatio, verticalRatio)
//            break
//        }
//
//        let newSize = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)
//        return self.resize(newSize)
//    }

    /**
     指定サイズでリサイズする  (Exifの画像の向きが上に修正される)
     */
    @objc func resize(_ size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size, format: imageRendererFormat).image { (context) in
            draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        }
    }

//    /**
//     画像を標準の向きに修正する
//     */
//    @objc func fixOrientationUp() -> UIImage {
//        if self.imageOrientation == .up {
//            return self
//        }
//        guard let imageRef = self.cgImage else { return self }
//
//        let transform = self.transformForOrientation(self.size)
//        let bitmapInfo = imageRef.bitmapInfo
//        let colorSpace = imageRef.colorSpace ?? CGColorSpaceCreateDeviceRGB()
//
//        if let ctx = CGContext(data: nil,
//                               width: Int(self.size.width),
//                               height: Int(self.size.height),
//                               bitsPerComponent: imageRef.bitsPerComponent,
//                               bytesPerRow: 0,
//                               space: colorSpace,
//                               bitmapInfo: bitmapInfo.rawValue) {
//
//            ctx.concatenate(transform)
//
//            switch self.imageOrientation {
//            case .left: fallthrough
//            case .leftMirrored: fallthrough
//            case .right: fallthrough
//            case .rightMirrored:
//                ctx.draw(imageRef, in: CGRect(x: 0,y: 0,width: self.size.height,height: self.size.width))
//                break
//            default:
//                ctx.draw(imageRef, in: CGRect(x: 0,y: 0,width: self.size.width,height: self.size.height))
//                break
//            }
//
//            if let cgimg = ctx.makeImage() {
//                return UIImage.init(cgImage: cgimg)
//            }
//        }
//        return self
//    }

//    /**
//     画像を正しい向きにするためのTransformを取得する
//     */
//    private func transformForOrientation(_ newSize: CGSize) -> CGAffineTransform {
//        var transform = CGAffineTransform.identity
//
//        switch self.imageOrientation {
//        case .down: fallthrough       // EXIF = 3
//        case .downMirrored:           // EXIF = 4
//            transform = transform.translatedBy(x: newSize.width, y: newSize.height)
//            transform = transform.rotated(by: .pi)
//            break
//
//        case .left: fallthrough       // EXIF = 6
//        case .leftMirrored:           // EXIF = 5
//            transform = transform.translatedBy(x: newSize.width, y: 0)
//            transform = transform.rotated(by: .pi / 2.0)
//            break
//
//        case .right: fallthrough      // EXIF = 8
//        case .rightMirrored:          // EXIF = 7
//            transform = transform.translatedBy(x: 0, y: newSize.height)
//            transform = transform.rotated(by: .pi / -2.0)
//            break
//
//        case .up: fallthrough
//        case .upMirrored: fallthrough
//        default:
//            break
//        }
//
//        switch self.imageOrientation {
//        case .upMirrored: fallthrough    // EXIF = 2
//        case .downMirrored:              // EXIF = 4
//            transform = transform.translatedBy(x: newSize.width, y: 0)
//            transform = transform.scaledBy(x: -1, y: 1)
//            break;
//
//        case .leftMirrored: fallthrough  // EXIF = 5
//        case .rightMirrored:             // EXIF = 7
//            transform = transform.translatedBy(x: newSize.height, y: 0)
//            transform = transform.scaledBy(x: -1, y: 1)
//            break;
//
//        case .up: fallthrough
//        case .down: fallthrough
//        case .left: fallthrough
//        case .right: fallthrough
//        default:
//            break
//        }
//        return transform
//    }

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

