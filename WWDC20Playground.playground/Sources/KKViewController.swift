import UIKit

public class KKViewController: UIViewController {
    
    private var curDrawingView: DrawView?
    private var drawArray: [DrawView] = []
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = boardColor
        
        view.addSubview(bigCircle)
        view.addSubview(smallCircle)
        view.addSubview(dotView)
        update(bigRadius: toolView.outCircleRadiusSlider.currentValue, smallRadius: toolView.inCircleRaduisSlider.currentValue, dotRadius: toolView.inCircleDotRaduisSlider.currentValue)
        
        view.addSubview(toolView)
        
        startBtn.frame = CGRect(x: 40, y: view.frame.maxY - 50, width: ScreenWidth - 80, height: 40)
        view.addSubview(startBtn)
        
        view.addSubview(redrawBtn)
    }
    
    private lazy var toolView: KKToolView = {
        let height: CGFloat = CGFloat(KKToolView.normalHeight)
        let toolView = KKToolView(frame: CGRect(x: 0, y: ScreenHeight - height, width: ScreenWidth, height: height))
        toolView.backgroundColor = UIColor(red: 235 / 255.0, green: 235 / 255.0, blue: 235 / 255.0, alpha: 1.0)
        toolView.delegate = self
        return toolView
    }()
    
    private lazy var startBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Start", for: .normal)
        btn.setTitle("End", for: .highlighted)
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.backgroundColor = UIColor(red: 175 / 255.0, green: 238 / 255.0, blue: 238 / 255.0, alpha: 1.0)
        btn.setTitleColor(.black, for: .normal)
        btn.layer.cornerRadius = 5
        btn.layer.masksToBounds = true
        
        btn.addTarget(self, action: #selector(startBtnClick), for: .touchDown)
        btn.addTarget(self, action: #selector(startBtnCancel), for: .touchUpInside)
        
        return btn
    }()
    
    private lazy var redrawBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Reset", for: .normal)
        btn.sizeToFit()
        btn.frame.origin.x = self.view.frame.width - btn.frame.width - 10
        btn.frame.origin.y = 20
        btn.addTarget(self, action: #selector(redrawClick), for: .touchUpInside)
        
        return btn
    }()
    
    private lazy var bigCircle: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.alpha = 0.3
        
        return view
    }()
    
    private lazy var smallCircle: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.alpha = 0.3
        
        return view
    }()
    
    private lazy var dotView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5
        view.frame.size = CGSize(width: 10, height: 10)
        view.backgroundColor = .red
        
        return view
    }()
}

extension KKViewController {
    
    @objc func startBtnClick() {
        let drawView = DrawView(frame: view.bounds)
        drawView.start(color: toolView.colorSelection.currentColor,
                       outRadius: toolView.outCircleRadiusSlider.currentValue,
                       inRadius: toolView.inCircleRaduisSlider.currentValue,
                       inDotRadius: toolView.inCircleDotRaduisSlider.currentValue,
                       showAnimate: toolView.showAnimateSwitch.isOn)
        view.insertSubview(drawView, belowSubview: toolView)
        curDrawingView = drawView
        drawView.delegate = self
        drawArray.append(drawView)
        
        toolView.hide()
    }
    
    @objc func startBtnCancel() {
        guard let curDrawingView = curDrawingView else {
            return
        }
        curDrawingView.stop()
        self.curDrawingView = nil
        
        resetViews()
    }
    
    @objc func redrawClick() {
        let alertVC = UIAlertController(title: "Tip", message: "Which content do you want to reset?", preferredStyle: .actionSheet)
        
        let allAction = UIAlertAction(title: "All", style: .default) { (_) in
            for view in self.drawArray {
                view.removeFromSuperview()
            }
            self.resetViews()
        }
        
        let lastOneAction = UIAlertAction(title: "Latest", style: .default) { (_) in
            if let last = self.drawArray.last {
                last.removeFromSuperview()
            }
            self.resetViews()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertVC.addAction(allAction)
        alertVC.addAction(lastOneAction)
        alertVC.addAction(cancelAction)
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func resetViews() {
        smallCircle.transform = CGAffineTransform(rotationAngle: 0)
        update(bigRadius: toolView.outCircleRadiusSlider.currentValue, smallRadius: toolView.inCircleRaduisSlider.currentValue, dotRadius: toolView.inCircleDotRaduisSlider.currentValue)
    }
}

extension KKViewController : KKToolViewDelegate {
    func slider(_ slider: KKSlider, didChangedValue: Int) {
        update(bigRadius: toolView.outCircleRadiusSlider.currentValue, smallRadius: toolView.inCircleRaduisSlider.currentValue, dotRadius: toolView.inCircleDotRaduisSlider.currentValue)
    }
    
    public func update(bigRadius: Int, smallRadius: Int, dotRadius: Int) {
        
        let bounds = self.view.bounds
        let center = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.5)
        
        bigCircle.frame.size = CGSize(width: bigRadius * 2, height: bigRadius * 2)
        bigCircle.center = center
        bigCircle.layer.cornerRadius = CGFloat(bigRadius)
        
        smallCircle.frame.size = CGSize(width: smallRadius * 2, height: smallRadius * 2)
        smallCircle.center = center
        smallCircle.layer.cornerRadius = CGFloat(smallRadius)
        
        let dotCenter = CGPoint(x: bounds.width * 0.5 + 5 - CGFloat(dotRadius), y: bounds.height * 0.5)
        dotView.center = dotCenter
    }
}

extension KKViewController: DrawViewDelegate {
    
    func drawView(_ drawView: DrawView, circleCenter: CGPoint, dotCenter: CGPoint, radian: Double) {
        smallCircle.center = circleCenter
        smallCircle.transform = CGAffineTransform(rotationAngle: CGFloat(radian))
        dotView.center = dotCenter
    }
    
    func showAnimateSwitch(_ didChanged: Bool) {
        bigCircle.isHidden = !didChanged
        smallCircle.isHidden = !didChanged
        dotView.isHidden = !didChanged
    }
}

