//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    private lazy var _starView: RatingStar = {
        let starView = RatingStar(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        self.view.addSubview(starView)
        return starView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self._starView.center = self.view.center
        
        let calculate: ((Int) -> CGFloat) = { index -> CGFloat in
            return self.view.bounds.height - CGFloat(index * 30)
        }
        
        let outerRadiusSlider = createSlider(center: CGPoint(x: self.view.center.x, y: calculate(5)), action: #selector(outerSliderChanged))
        self.view.addSubview(outerRadiusSlider)
        
        let innerRadiusSlider = createSlider(center: CGPoint(x: self.view.center.x, y: calculate(4)), action: #selector(innerSliderChanged))
        self.view.addSubview(innerRadiusSlider)
        
        let radiusScaleSlider = createSlider(center: CGPoint(x: self.view.center.x, y: calculate(3)), action: #selector(radiusScaleChanged))
        self.view.addSubview(radiusScaleSlider)
        
        let ratingSlider = createSlider(center: CGPoint(x: self.view.center.x, y: calculate(2)), action: #selector(ratingChanged))
        self.view.addSubview(ratingSlider)
        
    }
    
    @objc func outerSliderChanged(_ sender: UISlider) {
        self._starView.outerCornerRadius = Double(sender.value*30)
    }
    
    @objc func innerSliderChanged(_ sender: UISlider) {
        self._starView.innerCornerRadius = Double(sender.value*30)
    }
    
    @objc func radiusScaleChanged(_ sender: UISlider) {
        self._starView.radiusScale = Double(sender.value)
    }
    
    @objc func ratingChanged(_ sender: UISlider) {
        self._starView.rating = Double(sender.value*5)
    }
    
    func createSlider(center: CGPoint, action: Selector) -> UISlider {
        let slider = UISlider(frame: CGRect(origin: CGPoint(), size: CGSize(width: 200, height: 20)))
        slider.center = center
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0
        slider.addTarget(self, action: action, for: .valueChanged)
        return slider
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
