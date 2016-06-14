
import Foundation
import UIKit

public extension UIImage {

    /**
     中心を正方形にクロップ
     */
    public func crop() -> UIImage {
        let w = self.size.width
        let h = self.size.height
        let size = (w < h) ? w : h

        let sx = self.size.width/2 - size/2
        let sy = self.size.height/2 - size/2
        let rect = CGRectMake(sx, sy, size, size)

        return self.crop(rect)
    }
    
    /**
     指定した位置をクロップ
    */
    public func crop(bounds: CGRect) -> UIImage {
        let cgImage = CGImageCreateWithImageInRect(self.CGImage, bounds)
        return UIImage.init(CGImage: cgImage!)
    }

    /**
     画像を標準の向きに修正する
     */
    public func fixOrientationUp() -> UIImage {
        if self.imageOrientation == .Up {
            return self
        }
        
        let transform = self.transformForOrientation(self.size)
        let imageRef = self.CGImage
        
        let ctx = CGBitmapContextCreate(nil,
                                        Int(self.size.width),
                                        Int(self.size.height),
                                        CGImageGetBitsPerComponent(imageRef),
                                        0,
                                        CGImageGetColorSpace(self.CGImage),
                                        CGImageGetBitmapInfo(self.CGImage).rawValue)
        CGContextConcatCTM(ctx, transform)
 
        switch self.imageOrientation {
        case .Left: fallthrough
        case .LeftMirrored: fallthrough
        case .Right: fallthrough
        case .RightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), imageRef)
            break
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), imageRef)
            break
        }
        
        let cgimg = CGBitmapContextCreateImage(ctx)
        return UIImage.init(CGImage: cgimg!)
    }

    /**
     長辺が指定したサイズになるように自動リサイズ
    */
    public func autoResize(maxsize: CGFloat) -> UIImage {
        if(maxsize > 0){
            let ratio = maxsize / max(self.size.width, self.size.height)
            var size = CGSizeMake(self.size.width * ratio, self.size.height * ratio)
            
            // オリジナルが設定より小さい場合
            if self.size.width <= size.width && self.size.height <= size.height {
                size = self.size
            }
            return resize(size, quality: .High)
        }
        return resize(self.size, quality: .High)
    }

    /**
     リサイズ
     */
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
        case .ScaleAspectFill: fallthrough
        default:
            ratio = max(horizontalRatio, verticalRatio)
            break
        }
        
        let newSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio)
        return self.resize(newSize, quality: quality)
    }

    /**
     リサイズ
     */
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

    private func resize(size: CGSize,
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
    
    /**
     画像を正しい向きにするためのTransformを取得
     */
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

    public func orientationString() -> String {
        switch self.imageOrientation {
        case .Up:               return "Up"
        case .Down:             return "Down"
        case .Left:             return "Left"
        case .Right:            return "Right"
        case .UpMirrored:       return "UpMirrored"
        case .DownMirrored:     return "DownMirrored"
        case .LeftMirrored:     return "LeftMirrored"
        case .RightMirrored:    return "RightMirrored"
        }
    }
    
}