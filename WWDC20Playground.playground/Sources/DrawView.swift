import UIKit

protocol DrawViewDelegate : NSObject {
    func drawView(_ drawView: DrawView, circleCenter: CGPoint, dotCenter: CGPoint, radian: Double)
}

class DrawView: UIView {

    public var lineColor: UIColor
    public weak var delegate: DrawViewDelegate?
    
    private var allLines: [CGPoint]
    private static var radian = 0
    
    private var circle: Circle
    private var bigCircle: Circle
    private var dotRadius: Double
    
    private var timer: Timer?
    
    public override init(frame: CGRect) {
        lineColor = .black
        allLines = []
        dotRadius = 0
        
        circle = Circle()
        bigCircle = Circle()

        
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    @objc func timerAction() {

        let (circlePoint, dotPoint, radian) = circle.center(at: bigCircle, with: dotRadius, radian: Double(DrawView.radian) * 0.1)
        self.allLines.append(dotPoint)
        DrawView.radian += 1
        
        self.setNeedsDisplay()
        
        delegate?.drawView(self, circleCenter: circlePoint, dotCenter: dotPoint, radian: radian)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

/// Touch
extension DrawView {
    
    public func start(color: UIColor, outRadius: Int, inRadius: Int, inDotRadius: Int, showAnimate: Bool) {
        lineColor = color
        circle.radius = Double(inRadius)
        bigCircle.radius = Double(outRadius)
        dotRadius = Double(inDotRadius)
        
        timer = Timer(timeInterval: (showAnimate ? 0.05 : 0.01), repeats: true) { (timer) in
            self.timerAction()
        }

        timer?.fire()
        RunLoop.current.add(timer!, forMode: .common)
    }
    
    public func stop() {
        DrawView.radian = 0
        timer?.invalidate()
    }
}

extension DrawView {
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            print("error ctx")
            return
        }
        
        if allLines.count != 0 {
            let startPoint = allLines.first!
            
            ctx.beginPath()
            ctx.move(to: startPoint)
            
            if allLines.count != 1 {
                for point in allLines {
                    ctx.addLine(to: point)
                }
            } else {
                ctx.addLine(to: startPoint)
            }

            ctx.setLineWidth(CGFloat(2))
            ctx.setStrokeColor(lineColor.cgColor)
            ctx.saveGState()
            ctx.strokePath()
        }
    }
}
