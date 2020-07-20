import UIKit

protocol KKToolViewDelegate : NSObject {
    func slider(_ slider: KKSlider, didChangedValue: Int)
    
    func showAnimateSwitch(_ didChanged:Bool)
}

class KKToolView: UIView {
    
    public weak var delegate: KKToolViewDelegate?
    
    public static let normalHeight = 350.0
    public static let hideHeight = 100.0
    
    private var hiddingNow: Bool
    
    override init(frame: CGRect) {
        hiddingNow = false
        
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initView() {
//        let screenWidth = UIScreen.main.bounds.size.width
        let screenWidth = ScreenWidth
        
        hideBtn.frame = CGRect(x: 0, y: 0, width: screenWidth, height: 30)
        addSubview(hideBtn)
        
        scrollView.frame = CGRect(x: 0, y: 30, width: screenWidth, height: self.frame.height - 60 - 30)
        addSubview(scrollView)
        
        scrollView.addSubview(colorSelection)
        
        outCircleTipLabel.frame = CGRect(x: 0, y: colorSelection.frame.maxY + 5, width: screenWidth, height: 20)
        scrollView.addSubview(outCircleTipLabel)
        outCircleRadiusSlider.frame = CGRect(x: 0, y: outCircleTipLabel.frame.maxY + 5, width: screenWidth, height: 30)
        scrollView.addSubview(outCircleRadiusSlider)
        
        inCircleTipLabel.frame = CGRect(x: 0, y: outCircleRadiusSlider.frame.maxY + 5, width: screenWidth, height: 20)
        scrollView.addSubview(inCircleTipLabel)
        inCircleRaduisSlider.frame = CGRect(x: 0, y: inCircleTipLabel.frame.maxY + 5, width: screenWidth, height: 50)
        scrollView.addSubview(inCircleRaduisSlider)
        
        inCircleDotTipLabel.frame = CGRect(x: 0, y: inCircleRaduisSlider.frame.maxY + 5, width: screenWidth, height: 20)
        scrollView.addSubview(inCircleDotTipLabel)
        inCircleDotRaduisSlider.frame = CGRect(x: 0, y: inCircleDotTipLabel.frame.maxY + 5, width: screenWidth, height: 50)
        scrollView.addSubview(inCircleDotRaduisSlider)
        
        animateTipLabel.frame = CGRect(x: 0, y: inCircleDotRaduisSlider.frame.maxY + 5, width: screenWidth, height: 20)
        scrollView.addSubview(animateTipLabel)
        showAnimateSwitch.frame = CGRect(x: 0, y: animateTipLabel.frame.maxY + 5, width: 50, height: 20)
        showAnimateSwitch.center.x = self.frame.width * 0.5
        scrollView.addSubview(showAnimateSwitch)
                
        scrollView.contentSize = CGSize(width: screenWidth, height: showAnimateSwitch.frame.maxY - colorSelection.frame.minY + 50)
    }
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        
        return scrollView
    }()
    
    private lazy var outCircleTipLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        label.textColor = .black
        label.text = "Outside circle's radius"
        
        return label
    }()
    
    private lazy var inCircleTipLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        label.textColor = .black
        label.text = "Inside circle's radius"
        
        return label
    }()
    
    private lazy var inCircleDotTipLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        label.textColor = .black
        label.text = "Inside dot's radius"
        
        return label
    }()
    
    private lazy var animateTipLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        label.textColor = .black
        label.text = "Show drawing process"
        
        return label
    }()
    
    public lazy var outCircleRadiusSlider: KKSlider = {
        let slider = KKSlider()
        slider.minimumValue = 20
        slider.maximunValue = Int(ScreenWidth * 0.5)
        slider.defaultValue(100)
        slider.delegate = self
        
        return slider
    }()
    
    public lazy var inCircleRaduisSlider: KKSlider = {
        let slider = KKSlider()
        slider.minimumValue = 20
        slider.maximunValue = 100
        slider.defaultValue(30)
        slider.delegate = self
        
        return slider
    }()
    
    public lazy var inCircleDotRaduisSlider: KKSlider = {
        let slider = KKSlider()
        slider.minimumValue = 20
        slider.maximunValue = 30
        slider.defaultValue(20)
        slider.delegate = self
        
        return slider
    }()
    
    public lazy var colorSelection: KKColorSelection = {
        return KKColorSelection(frame: CGRect(x: 0, y: 10, width: ScreenWidth, height: 50))
    }()
    
    public lazy var showAnimateSwitch: UISwitch = {
        let view = UISwitch()
        view.isOn = true
        view.addTarget(self, action: #selector(showAnimateSwitchAction), for: .valueChanged)
        
        return view
    }()
    
    private lazy var hideBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Hide setting view", for: .normal)
        btn.addTarget(self, action: #selector(hideOrShow), for: .touchUpInside)
        
        return btn
    }()
}

extension KKToolView {
    
    @objc func hideOrShow() {
        var height = 0.0
        if hiddingNow {
            // show
            hideBtn.setTitle("Hide setting view", for: .normal)
            height = KKToolView.normalHeight
        } else {
            hideBtn.setTitle("Show setting view", for: .normal)
            height = KKToolView.hideHeight
        }
        
        hiddingNow = !hiddingNow
        
        UIView.animate(withDuration: 0.25) {
            self.frame.origin.y = ScreenHeight - CGFloat(height)
            self.scrollView.isHidden = self.hiddingNow
        }
    }
    
    @objc func showAnimateSwitchAction() {
        delegate?.showAnimateSwitch(showAnimateSwitch.isOn)
    }
}

extension KKToolView: KKSliderDelegate {
    
    func slider(_ slider: KKSlider, didChangedValue: Int) {
        if slider == outCircleRadiusSlider {
            inCircleRaduisSlider.maximunValue = didChangedValue
            inCircleRaduisSlider.defaultValue(min(inCircleRaduisSlider.currentValue, didChangedValue))
            
            inCircleDotRaduisSlider.maximunValue = didChangedValue
            inCircleDotRaduisSlider.defaultValue(min(inCircleDotRaduisSlider.currentValue, didChangedValue))

        } else if slider == inCircleRaduisSlider {
            inCircleDotRaduisSlider.maximunValue = didChangedValue
            inCircleDotRaduisSlider.defaultValue(min(inCircleDotRaduisSlider.currentValue, didChangedValue))
        }
        
        delegate?.slider(slider, didChangedValue: didChangedValue)
    }
    
    func hide() {
        if !hiddingNow {
            hideOrShow()
        }
    }
}
