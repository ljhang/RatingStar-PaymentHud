//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    private var _loadingView: UIView!
    private var _successView: UIView!
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        
        let buttonWidth:CGFloat = 80.0
        let height = self.view.bounds.height/2
        let width = self.view.bounds.width - buttonWidth*2
        
        let showLoadingButton = UIButton(type: .system)
        showLoadingButton.frame = CGRect(x: 0, y: 0, width: buttonWidth, height: height)
        showLoadingButton.setTitle("展示加载", for: .normal)
        showLoadingButton.addTarget(self, action: #selector(showLoadingAction), for: .touchUpInside)
        self.view.addSubview(showLoadingButton)
        
        let hideLoadingButton = UIButton(type: .system)
        hideLoadingButton.frame = CGRect(x: width+buttonWidth, y: 0, width: buttonWidth, height: height)
        hideLoadingButton.setTitle("隐藏加载", for: .normal)
        hideLoadingButton.addTarget(self, action: #selector(hideLoadingAction), for: .touchUpInside)
        self.view.addSubview(hideLoadingButton)
        
        let loadingView = UIView(frame: CGRect(x: buttonWidth, y: 0, width: width, height: height))
        loadingView.backgroundColor = .white
        _loadingView = loadingView
        self.view.addSubview(loadingView)
        
        let showSuccessButton = UIButton(type: .system)
        showSuccessButton.frame = CGRect(x: 0, y: height, width: buttonWidth, height: height)
        showSuccessButton.setTitle("展示成功", for: .normal)
        showSuccessButton.addTarget(self, action: #selector(showSuccessAction), for: .touchUpInside)
        self.view.addSubview(showSuccessButton)
        
        let hideSuccessButton = UIButton(type: .system)
        hideSuccessButton.frame = CGRect(x: width+buttonWidth, y: height, width: buttonWidth, height: height)
        hideSuccessButton.setTitle("隐藏成功", for: .normal)
        hideSuccessButton.addTarget(self, action: #selector(hideSuccessAction), for: .touchUpInside)
        self.view.addSubview(hideSuccessButton)
        
        let successView = UIView(frame: CGRect(x: buttonWidth, y: height, width: width, height: height))
        successView.backgroundColor = .white
        _successView = successView
        self.view.addSubview(successView)
    }
    
    @objc func showLoadingAction() {
        let hud = PaymentLoadingHUD.showIn(view: self._loadingView)
        hud.animationRadius = 100
        hud.lineWidth = 1
        hud.strokeColor = .red
    }
    
    @objc func hideLoadingAction() {
        PaymentLoadingHUD.hideIn(view: self._loadingView)
    }
    
    @objc func showSuccessAction() {
        let hud = PaymentSuccessHUD.showIn(view: self._successView)
        hud.animationRadius = 100
        hud.lineWidth = 1
        hud.strokeColor = .red
    }
    
    @objc func hideSuccessAction() {
        PaymentSuccessHUD.hideIn(view: self._successView)
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
