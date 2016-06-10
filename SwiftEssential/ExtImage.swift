
import Foundation
import UIKit

public extension UIImage {

    // 中心を正方形にクロップ
    public func crop() -> UIImage {
        let w = self.size.width
        let h = self.size.width
        let size = (w < h) ? w : h

        let sx = self.size.width/2 - size/2
        let sy = self.size.height/2 - size/2
        let rect = CGRectMake(sx, sy, size, size)

        return self.crop(rect)
    }
    
    // 指定位置をクロップ
    public func crop(bounds: CGRect) -> UIImage {
        let cgImage = CGImageCreateWithImageInRect(self.CGImage, bounds)
        return UIImage.init(CGImage: cgImage!)
    }

    // 画像を標準の向きに修正する
    public func fixOrientation() -> UIImage {
        let imageRef = self.CGImage
        let w = CGFloat(CGImageGetWidth(imageRef))
        let h = CGFloat(CGImageGetHeight(imageRef))
        
        // Orientation = 1
        let size = CGSizeMake(w, h)
        var affineTransform: CGAffineTransform
        affineTransform = CGAffineTransformMakeScale(1, -1)
        affineTransform = CGAffineTransformTranslate(affineTransform, 0, -h)
        
        UIGraphicsBeginImageContext(size)
        let context = UIGraphicsGetCurrentContext()
        CGContextConcatCTM(context, affineTransform)
        CGContextDrawImage(context, CGRectMake(0, 0, w, h), imageRef)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    // 指定サイズでリサイズ（Exif:Orientationは考慮される）
    public func resize(size: CGSize,
                quality: CGInterpolationQuality) -> UIImage {

        var drawTransposed = false
    
        switch(self.imageOrientation){
        case .Left: fallthrough
        case .LeftMirrored: fallthrough
        case .Right: fallthrough
        case .RightMirrored:
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
    
    // アスペクト比を保ったまま自動リサイズ (Exif:Orientationは考慮される)
    public func resize(size: CGSize,
                quality: CGInterpolationQuality,
                contentMode: UIViewContentMode) -> UIImage {

        let horizontalRatio = size.width / self.size.width
        let verticalRatio = size.height / self.size.height
        let ratio: CGFloat
    
        switch contentMode {
        case .ScaleAspectFit:
            ratio = min(horizontalRatio, verticalRatio)
            break
        case .ScaleAspectFill:
            ratio = max(horizontalRatio, verticalRatio)
            break
        default:
            ratio = max(horizontalRatio, verticalRatio)
            break
        }
    
        let newSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio)
        return self.resize(newSize, quality: quality)
    }

    // Orientationを考慮したリサイズ
    public func resize(size: CGSize,
                quality: CGInterpolationQuality,
                transform: CGAffineTransform,
                transpose: Bool) -> UIImage {

        let newRect = CGRectIntegral(CGRectMake(0, 0, size.width, size.height))
        let transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width)
        let imageRef = self.CGImage
    
        let bitmapInfo = CGImageGetBitmapInfo(imageRef)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
    
        let bitmap = CGBitmapContextCreate(nil,
                                           Int(newRect.size.width),
                                           Int(newRect.size.height),
                                           CGImageGetBitsPerComponent(imageRef),
                                           0,
                                           colorSpace,
                                           bitmapInfo.rawValue)
        
        // Rotate and/or flip the image if required by its orientation
        CGContextConcatCTM(bitmap, transform)
    
        // Set the quality level to use when rescaling
        CGContextSetInterpolationQuality(bitmap, quality)
    
        // Draw into the context this scales the image
        CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef)
    
        // Get the resized image from the context and a UIImage
        let cgImageRef = CGBitmapContextCreateImage(bitmap)
        return UIImage.init(CGImage: cgImageRef!)
    }
    
    // 画像を正しい向きにするためのTransformを取得
    private func transformForOrientation(newSize: CGSize) -> CGAffineTransform {
        var transform = CGAffineTransformIdentity
        
        switch self.imageOrientation {
        case .Down: fallthrough       // EXIF = 3
        case .DownMirrored:           // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
            break
            
        case .Left: fallthrough       // EXIF = 6
        case .LeftMirrored:           // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0)
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2))
            break
            
        case .Right: fallthrough      // EXIF = 8
        case .RightMirrored:          // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height)
            transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2))
            break
            
        case .Up: fallthrough
        case .UpMirrored: fallthrough
        default:
            break
        }
        
        switch self.imageOrientation {
        case .UpMirrored: fallthrough    // EXIF = 2
        case .DownMirrored:              // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
            break;
            
        case .LeftMirrored: fallthrough  // EXIF = 5
        case .RightMirrored:             // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0)
            transform = CGAffineTransformScale(transform, -1, 1)
            break;
            
        case .Up: fallthrough
        case .Down: fallthrough
        case .Left: fallthrough
        case .Right: fallthrough
        default:
            break
        }
        return transform
    }

}