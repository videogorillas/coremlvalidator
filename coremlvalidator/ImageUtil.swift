//
//  ImageUtil.swift
//  coremlvalidator
//
//  Created by Aleksey Sevruk on 11/30/17.
//  Copyright © 2017 Aleksey Sevruk. All rights reserved.
//

import Foundation
import AppKit
import CoreGraphics

class ImageUtil {
    static func getPixelBuffer(from image: NSImage) -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
//        UIGraphicsPushContext(context!)
        // public /*not inherited*/ init(cgContext graphicsPort: CGContext, flipped initialFlippedState: Bool)
        NSGraphicsContext(cgContext: context!, flipped: false)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
//        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
    
    static func resizeImage(image:NSImage, size:CGSize) -> NSImage {
        let maxWidth = Float(size.width)
        let maxHeight = Float(size.height)
        
        // Create a new NSSize object with the newly calculated size
        let newSize:NSSize = NSSize(width: Int(maxWidth), height: Int(maxHeight))
        
        // Cast the NSImage to a CGImage
        var imageRect:CGRect = CGRect(origin: CGPoint(x:0, y:0), size: size)
        let imageRef = image.cgImage(forProposedRect: &imageRect, context: nil, hints: nil)
        
        // Create NSImage from the CGImage using the new size
        let imageWithNewSize = NSImage(cgImage: imageRef!, size: newSize)
        
        // Return the new image
        return imageWithNewSize
    }
}
