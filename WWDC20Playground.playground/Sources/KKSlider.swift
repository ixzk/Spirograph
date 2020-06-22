import UIKit

protocol KKSliderDelegate: NSObject {
    func slider(_ slider: KKSlider, didChangedValue: Int)
}

class KKSlider: UIView {
    
    public var minimumValue: Int
    public var maximunValue: Int
    
    public weak var delegate: KKSliderDelegate?
    
    private var _currentValue: Int
    public var currentValue: Int {
        set {
            _currentValue = newValue
            updateText()
        }
        get {
            return _currentValue
        }
    }
    
    override init(frame: CGRect) {
        minimumValue = 0
        maximunValue = 0
        _currentValue = 0
        
        super.init(frame: frame)
        initView()
    }
    
    private func initView() {
        addSubview(lineView)
        addSubview(blockView)
        blockView.addSubview(textLabel)
    }
    
    public func defaultValue(_ value: Int) {
        currentValue = value
        
        let maxLen = lineView.frame.width - blockView.frame.width
        let rate = (Double(value) - Double(minimumValue)) / Double(maximunValue - minimumValue)
        let curX = CGFloat(rate) * maxLen + lineView.frame.minX
        if curX.isNaN {
            return 
        }
        var frame = blockView.frame
        frame.origin.x = curX
        blockView.frame = frame
    }
    
    
    private lazy var lineView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: 10, y: 12.5, width: ScreenWidth - 20, height: 5)
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 2.5
        view.backgroundColor = UIColor(red: 245 / 255.0, green: 245 / 255.0, blue: 245 / 255.0, alpha: 1.0)
        
        return view
    }()
    
    private lazy var blockView: UIView = {
        let view = UIView()
        view.frame = CGRect(x:  10, y: 5, width: 50, height: 20)
        view.backgroundColor = .white
//        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 0)
        view.layer.shadowOpacity = 0.2
        
        view.isUserInteractionEnabled = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
        view.addGestureRecognizer(pan)
        
        return view
    }()
    
    private lazy var textLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 50, height: 20)
        label.font = .boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .gray
        
        return label
    }()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// Action
extension KKSlider {
    
    @objc func panAction(_ gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed {
            let view = gesture.view!
            let translation = gesture.translation(in: view)
            let point = CGPoint(x: view.center.x + translation.x, y: view.center.y)
            gesture.setTranslation(.zero, in: gesture.view)
            
            let width = view.frame.width
            if point.x <= self.lineView.frame.minX + width * 0.5 || point.x >= self.lineView.frame.maxX - width * 0.5 {
                return
            }
            
            view.center = point
            
            // calculate currentValue
            let maxLen = self.lineView.frame.width - width
            let cur = view.frame.minX - self.lineView.frame.minX
            let rate = cur / maxLen
            let curValue = Double(maximunValue - minimumValue) * Double(rate) + Double(minimumValue)
            currentValue = Int(floor(curValue))
            if currentValue < minimumValue {
                currentValue = minimumValue
            }
            if currentValue > maximunValue {
                currentValue = maximunValue
            }
            
            delegate?.slider(self, didChangedValue: currentValue)
        }
    }
    
    func updateText() {
        textLabel.text = String(currentValue)
    }
}
