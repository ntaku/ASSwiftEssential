
import Foundation
import UIKit

public extension UIImage {

    /**
     JPGに変換
     */
    public func toJpeg(_ quality: CGFloat) -> Data? {
        return UIImageJPEGRepresentation(self, quality)
    }

    /**
     PNGに変換
     */
    public func toPng() -> Data? {
        return UIImagePNGRepresentation(self)
    }

    /**
     中心を正方形にクロップ
     */
    public func crop() -> UIImage {
        let w = self.size.width
        let h = self.size.height
        let size = (w < h) ? w : h

        let sx = self.size.width/2 - size/2
        let sy = self.size.height/2 - size/2
        let rect = CGRect(x: sx, y: sy, width: size, height: size)

        return self.crop(rect)
    }

    /**
     指定した位置をクロップ
     */
    public func crop(_ bounds: CGRect) -> UIImage {
        let cgImage = self.cgImage?.cropping(to: bounds)
        return UIImage.init(cgImage: cgImage!)
    }

    /**
     画像を標準の向きに修正する
     */
    public func fixOrientationUp() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }

        let transform = self.transformForOrientation(self.size)
        let imageRef = self.cgImage

        let ctx = CGContext(data: nil,
                            width: Int(self.size.width),
                            height: Int(self.size.height),
                            bitsPerComponent: (imageRef?.bitsPerComponent)!,
                            bytesPerRow: 0,
                            space: (self.cgImage?.colorSpace!)!,
                            bitmapInfo: (self.cgImage?.bitmapInfo.rawValue)!)
        ctx?.concatenate(transform)

        switch self.imageOrientation {
        case .left: fallthrough
        case .leftMirrored: fallthrough
        case .right: fallthrough
        case .rightMirrored:
            ctx?.draw(imageRef!, in: CGRect(x: 0,y: 0,width: self.size.height,height: self.size.width))
            break
        default:
            ctx?.draw(imageRef!, in: CGRect(x: 0,y: 0,width: self.size.width,height: self.size.height))
            break
        }

        let cgimg = ctx?.makeImage()
        return UIImage.init(cgImage: cgimg!)
    }

    /**
     長辺が指定したサイズになるように自動リサイズ
     */
    public func autoResize(_ maxsize: CGFloat) -> UIImage {
        if(maxsize > 0){
            let ratio = maxsize / max(self.size.width, self.size.height)
            var size = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)

            // オリジナルが設定より小さい場合
            if self.size.width <= size.width && self.size.height <= size.height {
                size = self.size
            }
            return resize(size, quality: .high)
        }
        return resize(self.size, quality: .high)
    }

    /**
     リサイズ
     */
    public func resize(_ size: CGSize,
                       quality: CGInterpolationQuality,
                       contentMode: UIViewContentMode) -> UIImage {

        let horizontalRatio = size.width / self.size.width
        let verticalRatio = size.height / self.size.height
        let ratio: CGFloat

        switch contentMode {
        case .scaleAspectFit:
            ratio = min(horizontalRatio, verticalRatio)
            break
        case .scaleAspectFill: fallthrough
        default:
            ratio = max(horizontalRatio, verticalRatio)
            break
        }

        let newSize = CGSize(width: self.size.width * ratio, height: self.size.height * ratio)
        return self.resize(newSize, quality: quality)
    }

    /**
     リサイズ
     */
    public func resize(_ size: CGSize,
                       quality: CGInterpolationQuality) -> UIImage {

        var drawTransposed = false

        switch(self.imageOrientation){
        case .left: fallthrough
        case .leftMirrored: fallthrough
        case .right: fallthrough
        case .rightMirrored:
            drawTransposed = true
            break
        default:
            drawTransposed = false
        }

        return self.resize(size,
                           quality: quality,
                           transform: self.transformForOrientation(size),
                           transpose: drawTransposed)
    }

    fileprivate func resize(_ size: CGSize,
                            quality: CGInterpolationQuality,
                            transform: CGAffineTransform,
                            transpose: Bool) -> UIImage {

        let newRect = CGRect(x: 0, y: 0, width: size.width, height: size.height).integral
        let transposedRect = CGRect(x: 0, y: 0, width: newRect.size.height, height: newRect.size.width)
        let imageRef = self.cgImage

        let bitmapInfo = imageRef?.bitmapInfo
        let colorSpace = CGColorSpaceCreateDeviceRGB()

        let bitmap = CGContext(data: nil,
                               width: Int(newRect.size.width),
                               height: Int(newRect.size.height),
                               bitsPerComponent: (imageRef?.bitsPerComponent)!,
                               bytesPerRow: 0,
                               space: colorSpace,
                               bitmapInfo: (bitmapInfo?.rawValue)!)

        // Rotate and/or flip the image if required by its orientation
        bitmap?.concatenate(transform)

        // Set the quality level to use when rescaling
        bitmap!.interpolationQuality = quality

        // Draw into the context this scales the image
        bitmap?.draw(imageRef!, in: transpose ? transposedRect : newRect)

        // Get the resized image from the context and a UIImage
        let cgImageRef = bitmap?.makeImage()
        return UIImage.init(cgImage: cgImageRef!)
    }

    /**
     画像を正しい向きにするためのTransformを取得
     */
    fileprivate func transformForOrientation(_ newSize: CGSize) -> CGAffineTransform {
        var transform = CGAffineTransform.identity

        switch self.imageOrientation {
        case .down: fallthrough       // EXIF = 3
        case .downMirrored:           // EXIF = 4
            transform = transform.translatedBy(x: newSize.width, y: newSize.height)
            transform = transform.rotated(by: CGFloat(M_PI))
            break

        case .left: fallthrough       // EXIF = 6
        case .leftMirrored:           // EXIF = 5
            transform = transform.translatedBy(x: newSize.width, y: 0)
            transform = transform.rotated(by: CGFloat(M_PI_2))
            break

        case .right: fallthrough      // EXIF = 8
        case .rightMirrored:          // EXIF = 7
            transform = transform.translatedBy(x: 0, y: newSize.height)
            transform = transform.rotated(by: CGFloat(-M_PI_2))
            break

        case .up: fallthrough
        case .upMirrored: fallthrough
        default:
            break
        }

        switch self.imageOrientation {
        case .upMirrored: fallthrough    // EXIF = 2
        case .downMirrored:              // EXIF = 4
            transform = transform.translatedBy(x: newSize.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break;

        case .leftMirrored: fallthrough  // EXIF = 5
        case .rightMirrored:             // EXIF = 7
            transform = transform.translatedBy(x: newSize.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            break;

        case .up: fallthrough
        case .down: fallthrough
        case .left: fallthrough
        case .right: fallthrough
        default:
            break
        }
        return transform
    }

    public func orientationString() -> String {
        switch self.imageOrientation {
        case .up:               return "Up"
        case .down:             return "Down"
        case .left:             return "Left"
        case .right:            return "Right"
        case .upMirrored:       return "UpMirrored"
        case .downMirrored:     return "DownMirrored"
        case .leftMirrored:     return "LeftMirrored"
        case .rightMirrored:    return "RightMirrored"
        }
    }

}
