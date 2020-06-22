import Foundation
import UIKit

struct Circle {
    public var radius: Double
    
    init() {
        radius = 0.0
    }
    
    // 求绕点圆心位置
    public func center(at outCircle: Circle, with selectedPointRadius: Double, radian: Double) -> (circleCenter: CGPoint, dotPoint: CGPoint, radian: Double) {
        // 内圆圆心位置
        let thisCenter = outCircle._point(radius: outCircle.radius - self.radius, radian: radian)
        // 计算绕点弧度 (公转为逆时针，则自转为顺时针)
        var selectedRadian = (outCircle.radius / self.radius * radian)
        selectedRadian = 2 * Double.pi - selectedRadian.truncatingRemainder(dividingBy: (2 * Double.pi))
        // 计算绕点坐标
        let point = self._point(center:thisCenter, radius: selectedPointRadius, radian: selectedRadian)
        
        return (thisCenter, point, selectedRadian)
    }
}

/// Private
extension Circle {
    // 通过弧度求圆上的点
    private func _point(center: CGPoint, radius: Double, radian: Double) -> CGPoint {
        return CGPoint(x: Double(center.x) + radius * cos(radian), y: Double(center.y) + radius * sin(radian))
    }
    
    private func _point(radius: Double, radian: Double) -> CGPoint {
        // 默认中点
        return _point(center: CGPoint(x: ScreenWidth * 0.5, y: ScreenHeight * 0.5), radius: radius, radian: radian)
    }
}
