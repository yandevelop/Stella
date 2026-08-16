import UIKit
import libroot

class SnowFactory {
    static var deviceBounds: CGRect {
        return UIScreen.main.bounds
    }

    static func createSnowEmitterLayer(withBounds bounds: CGRect? = nil, configuration: SnowflakeConfiguration) -> CAEmitterLayer {
        let bounds = bounds ?? deviceBounds

        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterShape = .line
        emitterLayer.emitterSize = CGSize(width: bounds.size.width, height: 0)

        emitterLayer.emitterPosition = CGPoint(x: bounds.size.width / 2, y: -30)
        emitterLayer.beginTime = CACurrentMediaTime()
        emitterLayer.emitterCells = [createSnowEmitterCell(configuration: configuration)]

        return emitterLayer
    }

    static func createSnowEmitterCell(configuration: SnowflakeConfiguration) -> CAEmitterCell {
        let emitterCell = CAEmitterCell()
        emitterCell.birthRate = Float(configuration.particleBirthRate)
        emitterCell.yAcceleration = configuration.particleSpeed
        emitterCell.xAcceleration = configuration.particleWind

        emitterCell.lifetime = 20
        emitterCell.lifetimeRange = 5
        emitterCell.velocity = -30
        emitterCell.velocityRange = -20
        
        emitterCell.emissionRange = Double.pi / 4
        emitterCell.spin = CGFloat.random(in: -0.5...0.5)
        emitterCell.spinRange = CGFloat.random(in: 0...1.0)

        emitterCell.scale = 0.06
        emitterCell.scaleRange = Double.pi
        emitterCell.alphaRange = 0.5
        emitterCell.alphaSpeed = -0.05

        emitterCell.color = configuration.particleColor.cgColor

        if let settings = StellaPreferences.shared.settings {
            emitterCell.contents = getCustomImage(for: configuration.name, settings: settings)?.cgImage ?? defaultSnowflakeImage
        } else {
            emitterCell.contents = defaultSnowflakeImage
        }

        emitterCell.name = "snowflake"

        return emitterCell
    }

    static var defaultSnowflakeImage: CGImage {
        return UIImage(contentsOfFile: jbRootPath("/Library/Application Support/Stella.bundle/snowflake.png"))!.cgImage!
    }

    private static func getCustomImage(for name: String, settings: StellaSettings) -> UIImage? {
        let (enabled, imageData, imageSize): (Bool, Data?, Float)
        
        switch name {
        case "lockscreen":
            enabled = settings.lockscreenCustomImageEnabled
            imageData = settings.lockscreenCustomImageData
            imageSize = settings.lockscreenCustomImageSize
        case "homescreen":
            enabled = settings.homescreenCustomImageEnabled
            imageData = settings.homescreenCustomImageData
            imageSize = settings.homescreenCustomImageSize
        default:
            return nil
        }

        guard enabled, let data = imageData, data.count > 0, let image = UIImage(data: data) else {
            return nil
        }

        let newSize = CGSize(width: CGFloat(imageSize), height: CGFloat(imageSize))
        let resizedImage = resizeImage(image: image, targetSize: newSize)
        return resizedImage
    }

    static func createStaticSnowEmitterCell() -> CAEmitterCell {
        let emitterCell = CAEmitterCell()

        emitterCell.contents = defaultSnowflakeImage
        emitterCell.color = UIColor.white.cgColor
        emitterCell.scale = 0.06
        emitterCell.scaleRange = Double.pi
        emitterCell.lifetime = 5
        
        if let birthRate = StellaManager.shared.lockscreenConfig?.particleBirthRate {
            if birthRate <= 7 {
                emitterCell.birthRate = Float(Int(birthRate) / 2)
            } else {
                emitterCell.birthRate = Float(Int(birthRate) / 5)
            }
        }

        emitterCell.spin = -0.5
        emitterCell.spinRange = 1.0
        emitterCell.alphaSpeed = -0.8 / emitterCell.lifetime

        return emitterCell
    }

    private static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(origin: .zero, size: newSize)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        defer { UIGraphicsEndImageContext() }

        return newImage!
    }

    static func createStaticSnowEmitterLayer(withBounds bounds: CGRect? = nil) -> CAEmitterLayer {
        let bounds = bounds ?? deviceBounds

        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterShape = .line
        emitterLayer.emitterSize = CGSize(width: bounds.size.width * 0.9, height: 0)

        emitterLayer.emitterPosition = CGPoint(x: bounds.size.width / 2, y: 0)
        emitterLayer.beginTime = CACurrentMediaTime()
        emitterLayer.emitterCells = [createStaticSnowEmitterCell()]

        return emitterLayer
    }
}