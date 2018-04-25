//
//  main.swift
//  coremlvalidator
//
//  Created by Aleksey Sevruk on 11/30/17.
//  Copyright © 2017 Aleksey Sevruk. All rights reserved.
//

import Foundation
import CoreML
import Cocoa
import AppKit
import Vision

let model = contexter()
let size = CGSize(width: 256, height: 256)

print("Hello, World!")

let home = FileManager.default.homeDirectoryForCurrentUser

let image1Path = "/Users/aleksey/Downloads/IMG_0009.JPG"
let image1Url = URL(fileURLWithPath: image1Path)
let image1 = NSImage(contentsOfFile: image1Url.path)

let resizedImage = ImageUtil.resizeImage(image: image1!, size: size)
let pixelBuffer = ImageUtil.getPixelBuffer(from: resizedImage)

guard let mlcontexterOutput = try? model.prediction(image: pixelBuffer!) else {
    fatalError()
}

print (mlcontexterOutput.output1)

