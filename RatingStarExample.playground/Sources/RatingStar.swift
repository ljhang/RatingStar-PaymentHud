import Foundation
import UIKit

public protocol RatingStarDelegate: AnyObject {
    func ratingStar(_ ratingStar: RatingStar, didFinish rating: Double)
}

public class RatingStar: UIView {
    public weak var delegate: RatingStarDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private var _viewSize: CGSize = .zero
    
    private func setup() {
        let layers = createAllStarLayers(rating: rating)
        layer.sublayers = layers
        updateSize(layers: layers)
    }
    
    override public var intrinsicContentSize: CGSize {
        return _viewSize
    }
    
    // MARK: - touch
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if disableTouch {
            return
        }
        guard let location = touchLocationFrom(touches: touches) else {
            return
        }
        
        let rating = touchRating(position: location, starNumber: starNumber, starSize: starSize, starMargin: starMargin, fillMode: fillMode)
        self.rating = rating
    }
    
    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if disableTouch {
            return
        }
        guard let location = touchLocationFrom(touches: touches) else {
            return
        }
        
        let rating = touchRating(position: location, starNumber: starNumber, starSize: starSize, starMargin: starMargin, fillMode: fillMode)
        self.rating = rating
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if disableTouch {
            return
        }
        
        self.delegate?.ratingStar(self, didFinish: self.rating)
    }
    
    // MARK: - Properties inspectable
    
    /// 五角星已显示进度的填充颜色
    @IBInspectable open dynamic var fillColor: UIColor = .init(red: 240/255, green: 124/255, blue: 66/255, alpha: 1.0) {
        didSet {
            setup()
        }
    }
    
    /// 五角星未选进度的填充颜色
    @IBInspectable open dynamic var emptyColor: UIColor = .init(red: 234/255, green: 234/255, blue: 234/255, alpha: 1.0) {
        didSet {
            setup()
        }
    }
    
    /// 五角星边框颜色
    @IBInspectable open dynamic var borderColor: UIColor? = nil {
        didSet {
            setup()
        }
    }
    
    /// 五角星已显示的进度
    @IBInspectable open dynamic var rating: Double = 0 {
        didSet {
            if oldValue != rating {
                setup()
            }
        }
    }
    
    /// 五角星的显示填充类型
    open dynamic var fillMode: StarFillMode = .precise {
        didSet {
            setup()
        }
    }
    
    /// 单个五角星的大小
    @IBInspectable open dynamic var starSize: Double = 150 {
        didSet {
            setup()
        }
    }
    
    /// 五角星的数量
    @IBInspectable open dynamic var starNumber: Int = 1 {
        didSet {
            setup()
        }
    }
    
    /// 五角星之间的间距
    @IBInspectable open dynamic var starMargin: Double = 0 {
        didSet {
            setup()
        }
    }
    
    /// 是否可触碰去修改五角星的显示进度
    @IBInspectable open dynamic var disableTouch: Bool = false
    
    /// 五角星外角的圆角大小
    @IBInspectable open dynamic var outerCornerRadius: Double = 0 {
        didSet {
            setup()
        }
    }
    
    /// 五角星内角的圆角大小
    @IBInspectable open dynamic var innerCornerRadius: Double = 0 {
        didSet {
            setup()
        }
    }
    
    /// 五角星内接圆与外接圆的半径缩放比例
    @IBInspectable open dynamic var radiusScale: Double = StarLayer.sin_degree(18)/StarLayer.sin_degree(54) {
        didSet {
            setup()
         }
    }
}

private extension RatingStar {
    func updateSize(layers: [CALayer]) {
        _viewSize = calculateSizeToFit(layers: layers)
        invalidateIntrinsicContentSize()
        frame.size = intrinsicContentSize
    }
    
    func calculateSizeToFit(layers: [CALayer]) -> CGSize {
        var size = CGSize()

        for layer in layers {
            if layer.frame.maxX > size.width {
                size.width = layer.frame.maxX
        }
        if layer.frame.maxY > size.height {
            size.height = layer.frame.maxY
            }
        }
        return size
    }
    
    func createAllStarLayers(rating: Double) -> [CALayer] {
        var starRemainder = filledStars(rating: rating, starNumber: starNumber)
        
        var starLayers: [CALayer] = []
        (0..<starNumber).forEach { index in
            let singleFillLevel = singleStarFillLevel(ratingRemainder: starRemainder, fillMode: fillMode)
            let containerLayer = createStarContainer(size: starSize, fillLevel: singleFillLevel)
            starLayers.append(containerLayer)
            starRemainder -= 1
        }
        positionStarLayers(layers: starLayers, starMargin: starMargin)
        return starLayers
    }
    
    func positionStarLayers(layers: [CALayer], starMargin: Double) {
        var positionX:CGFloat = 0
        for layer in layers {
            layer.position.x = positionX
            positionX += layer.bounds.width + CGFloat(starMargin)
        }
    }
    
    func filledStars(rating: Double, starNumber: Int) -> Double {
        if rating > Double(starNumber) {
            return Double(starNumber)
        }
        
        if rating < 0 {
            return 0
        }
        return rating
    }
    
    func createStarContainer(size: Double, fillLevel: Double) -> CALayer {
        let starPath = StarLayer.createStarPath(size: size, radiusScale: radiusScale, outerCornerRadius: outerCornerRadius, innerCornerRadius: innerCornerRadius)
//        let transform = StarLayer.scale(path: starPath, to: size)
//        starPath.apply(transform)
        
        let containerLayer = StarLayer.createContainerLayer(size: size)
        
        let emptyShapeLayer = StarLayer.createShapeLayer(path: starPath.cgPath, fillColor: emptyColor, strokeColor: borderColor, size: size)
        containerLayer.addSublayer(emptyShapeLayer)
        
        let filledShapeLayer = StarLayer.createShapeLayer(path: starPath.cgPath, fillColor: fillColor, strokeColor: borderColor, size: size)
        filledShapeLayer.bounds.size.width *= CGFloat(fillLevel)
        containerLayer.addSublayer(filledShapeLayer)
        
        return containerLayer
    }
    
    func touchLocationFrom(touches: Set<UITouch>) -> CGFloat? {
        guard let touch = touches.first else {
            return nil
        }
        let location = touch.location(in: self).x
        return location
    }
    
    func singleStarFillLevel(ratingRemainder: Double, fillMode: StarFillMode) -> Double {
        var result = ratingRemainder
        if result > 1 { result = 1 }
        if result < 0 { result = 0 }
        return roundFillLevel(starFillLevel: result, fillMode: fillMode)
    }
    
    func roundFillLevel(starFillLevel: Double, fillMode: StarFillMode) -> Double {
        switch fillMode {
        case .full:
            return Double(round(starFillLevel))
        case .half:
            return Double(round(starFillLevel * 2) / 2)
        case .precise :
            return starFillLevel
        }
    }
    
    func touchRating(position: CGFloat, starNumber: Int, starSize: Double, starMargin: Double, fillMode: StarFillMode) -> Double {
        var rating = preciseRating(position: Double(position), starNumber: starNumber, starSize: starSize, starMargin: starMargin)
        if fillMode == .half {
            rating += 0.20
        }
        if fillMode == .full {
            rating += 0.45
        }
        rating = displayedRatingFromPreciseRating(preciseRating: rating, fillMode: fillMode, totalStars: starNumber)
        rating = max(0, rating) // Can't be less than min rating
        return rating
    }
    
    func displayedRatingFromPreciseRating(preciseRating: Double, fillMode: StarFillMode, totalStars: Int) -> Double {
        let starFloorNumber = floor(preciseRating)
        let singleStarRemainder = preciseRating - starFloorNumber
        
        var displayedRating = starFloorNumber + singleStarFillLevel(ratingRemainder: singleStarRemainder, fillMode: fillMode)
        displayedRating = min(Double(totalStars), displayedRating) // Can't go bigger than number of stars
        displayedRating = max(0, displayedRating) // Can't be less than zero
        
        return displayedRating
    }
    
    func preciseRating(position: Double, starNumber: Int, starSize: Double, starMargin: Double) -> Double {
        if position < 0 { return 0 }
        var positionRemainder = position

        var rating: Double = Double(Int(position / (starSize + starMargin)))
        if Int(rating) > starNumber { return Double(starNumber) }
        positionRemainder -= rating * (starSize + starMargin)

        if positionRemainder > starSize {
            rating += 1
        } else {
            rating += positionRemainder / starSize
        }
        return rating
    }
}
