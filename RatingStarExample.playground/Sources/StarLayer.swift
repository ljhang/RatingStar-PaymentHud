import Foundation
import UIKit

/**
 创建单个五角星的图层。
 参考文章：
 https://www.jianshu.com/p/3baf402dd8a5
 https://www.jianshu.com/p/a275d23f6463
 */
struct StarLayer {
    static func createContainerLayer(size: Double) -> CALayer {
        let layer = CALayer()
        layer.anchorPoint = CGPoint()
        layer.masksToBounds = true
        layer.bounds.size = CGSize(width: size, height: size)
        layer.isOpaque = true
        return layer
    }
    
    /// 创建五角星图层
    /// - Parameters:
    ///   - path: 图层的路径
    ///   - fillColor: 填充颜色
    ///   - strokeColor: 边框颜色
    ///   - size: 大小
    static func createShapeLayer(path: CGPath, fillColor: UIColor, strokeColor: UIColor?, size: Double) -> CALayer {
        let layer = CAShapeLayer()
        layer.anchorPoint = CGPoint()
        layer.fillColor = fillColor.cgColor
        layer.bounds.size = CGSize(width: size, height: size)
        layer.strokeColor = strokeColor?.cgColor
        layer.lineWidth = 0.5
        layer.masksToBounds = true
        layer.path = path
        layer.isOpaque = true
        layer.backgroundColor = UIColor.orange.cgColor
        return layer
    }
    
    /// 通过贝塞尔曲线画出五角星
    /// - Parameters:
    ///   - size: 大小
    ///   - radiusScale: 五角星外接圆与内接圆的半径比例
    ///   - outerCornerRadius: 五角星外角的弧度
    ///   - innerCornerRadius: 五角星内角的弧度
    static func createStarPath(size: Double, radiusScale: Double, outerCornerRadius: Double, innerCornerRadius: Double) -> UIBezierPath {
        //在数学坐标轴的坐标
        let outer_r: Double = size/2.0
        
        let a_x: Double = 0
        let a_y = outer_r
        let b_x = cos_degree(18)*outer_r
        let b_y = sin_degree(18)*outer_r
        let c_x = cos_degree(54)*outer_r
        let c_y = -sin_degree(54)*outer_r
        let d_x = -cos_degree(54)*outer_r
        let d_y = -sin_degree(54)*outer_r
        let e_x = -cos_degree(18)*outer_r
        let e_y = sin_degree(18)*outer_r
        
        /// 内接圆与外部圆半径比例
        let r_scale = radiusScaleDetect(scale: radiusScale)
        let inner_r = r_scale * outer_r
        
        let aa_x: Double = 0
        let aa_y = -inner_r
        let bb_x = -inner_r*cos_degree(18)
        let bb_y = -inner_r*sin_degree(18)
        let cc_x = -inner_r*cos_degree(54)
        let cc_y = inner_r*sin_degree(54)
        let dd_x = inner_r*cos_degree(54)
        let dd_y = inner_r*sin_degree(54)
        let ee_x = inner_r*cos_degree(18)
        let ee_y = -inner_r*sin_degree(18)
        
        // 转换为View内部坐标
        let a_v = CGPoint(x: outer_r + a_x, y: outer_r - a_y)
        let b_v = CGPoint(x: outer_r + b_x, y: outer_r - b_y)
        let c_v = CGPoint(x: outer_r + c_x, y: outer_r - c_y)
        let d_v = CGPoint(x: outer_r + d_x, y: outer_r - d_y)
        let e_v = CGPoint(x: outer_r + e_x, y: outer_r - e_y)
        
        let aa_v = CGPoint(x: outer_r + aa_x, y: outer_r - aa_y)
        let bb_v = CGPoint(x: outer_r + bb_x, y: outer_r - bb_y)
        let cc_v = CGPoint(x: outer_r + cc_x, y: outer_r - cc_y)
        let dd_v = CGPoint(x: outer_r + dd_x, y: outer_r - dd_y)
        let ee_v = CGPoint(x: outer_r + ee_x, y: outer_r - ee_y)
                
        let outer_node_padding = CGFloat(radiusPaddingDetect(size: size/2, radius: outerCornerRadius))
        let inner_node_padding = CGFloat(radiusPaddingDetect(size: size/2, radius: innerCornerRadius))
        
        // cc到A线上某点的坐标
        let cc_a_outer_node = calculatePointInLine(padding: outer_node_padding, startPoint: cc_v, endPoint: a_v)
        let cc_a_inner_node = calculatePointInLine(padding: inner_node_padding, startPoint: a_v, endPoint: cc_v)
        // dd到A线上某点的坐标
        let dd_a_outer_node = calculatePointInLine(padding: outer_node_padding, startPoint: dd_v, endPoint: a_v)
        let dd_a_inner_node = calculatePointInLine(padding: inner_node_padding, startPoint: a_v, endPoint: dd_v)
        // dd到B线上某点的坐标
        let dd_b_outer_node = calculatePointInLine(padding: outer_node_padding, startPoint: dd_v, endPoint: b_v)
        let dd_b_inner_node = calculatePointInLine(padding: inner_node_padding, startPoint: b_v, endPoint: dd_v)
        // ee到B线上某点的坐标
        let ee_b_outer_node = calculatePointInLine(padding: outer_node_padding, startPoint: ee_v, endPoint: b_v)
        let ee_b_inner_node = calculatePointInLine(padding: inner_node_padding, startPoint: b_v, endPoint: ee_v)
        // ee到C线上某点的坐标
        let ee_c_outer_node = calculatePointInLine(padding: outer_node_padding, startPoint: ee_v, endPoint: c_v)
        let ee_c_inner_node = calculatePointInLine(padding: inner_node_padding, startPoint: c_v, endPoint: ee_v)
        // aa到C线上某点的坐标
        let aa_c_outer_node = calculatePointInLine(padding: outer_node_padding, startPoint: aa_v, endPoint: c_v)
        let aa_c_inner_node = calculatePointInLine(padding: inner_node_padding, startPoint: c_v, endPoint: aa_v)
        // aa到D线上某点的坐标
        let aa_d_outer_node = calculatePointInLine(padding: outer_node_padding, startPoint: aa_v, endPoint: d_v)
        let aa_d_inner_node = calculatePointInLine(padding: inner_node_padding, startPoint: d_v, endPoint: aa_v)
        // bb到D线上某点的坐标
        let bb_d_outer_node = calculatePointInLine(padding: outer_node_padding, startPoint: bb_v, endPoint: d_v)
        let bb_d_inner_node = calculatePointInLine(padding: inner_node_padding, startPoint: d_v, endPoint: bb_v)
        // bb到E线上某点的坐标
        let bb_e_outer_node = calculatePointInLine(padding: outer_node_padding, startPoint: bb_v, endPoint: e_v)
        let bb_e_inner_node = calculatePointInLine(padding: inner_node_padding, startPoint: e_v, endPoint: bb_v)
        // cc到E线上某点的坐标
        let cc_e_outer_node = calculatePointInLine(padding: outer_node_padding, startPoint: cc_v, endPoint: e_v)
        let cc_e_inner_node = calculatePointInLine(padding: inner_node_padding, startPoint: e_v, endPoint: cc_v)
        
        let starPath = UIBezierPath()
        starPath.move(to: cc_a_inner_node)
        
        /// A点外角曲线
        starPath.addLine(to: cc_a_outer_node)
        starPath.addQuadCurve(to: dd_a_outer_node, controlPoint: a_v)
        /// dd点内角曲线
        starPath.addLine(to: dd_a_inner_node)
        starPath.addQuadCurve(to: dd_b_inner_node, controlPoint: dd_v)
        
        /// B点外角曲线
        starPath.addLine(to: dd_b_outer_node)
        starPath.addQuadCurve(to: ee_b_outer_node, controlPoint: b_v)
        /// ee点内角曲线
        starPath.addLine(to: ee_b_inner_node)
        starPath.addQuadCurve(to: ee_c_inner_node, controlPoint: ee_v)
        
        /// C点外角曲线
        starPath.addLine(to: ee_c_outer_node)
        starPath.addQuadCurve(to: aa_c_outer_node, controlPoint: c_v)
        /// aa点内角曲线
        starPath.addLine(to: aa_c_inner_node)
        starPath.addQuadCurve(to: aa_d_inner_node, controlPoint: aa_v)
        
        /// D点外角曲线
        starPath.addLine(to: aa_d_outer_node)
        starPath.addQuadCurve(to: bb_d_outer_node, controlPoint: d_v)
        /// bb点内角曲线
        starPath.addLine(to: bb_d_inner_node)
        starPath.addQuadCurve(to: bb_e_inner_node, controlPoint: bb_v)
        
        /// E点外角曲线
        starPath.addLine(to: bb_e_outer_node)
        starPath.addQuadCurve(to: cc_e_outer_node, controlPoint: e_v)
        /// cc点内角曲线
        starPath.addLine(to: cc_e_inner_node)
        starPath.addQuadCurve(to: cc_a_inner_node, controlPoint: cc_v)
        
        starPath.close()
        return starPath
    }
    
    static func radiusScaleDetect(scale: Double) -> Double {
        var r_scale = scale
        if scale > 1.0 { r_scale = 1.0 }
        if scale < 0.0 { r_scale = 0.0 }
        return r_scale
    }
    
    static func radiusPaddingDetect(size: Double, radius: Double) -> Double {
        var _radius = radius
        if radius > size { _radius = size }
        if radius < 0 { _radius = 0 }
        return _radius
    }
    
    /// 根据两点坐标以及中间某点坐标距离端点的长度，计算该点的坐标
    /// - Parameters:
    ///   - padding: 距离端点的长度
    ///   - startPoint: 起点坐标
    ///   - endPoint: 终点坐标
    static func calculatePointInLine(padding: CGFloat, startPoint: CGPoint, endPoint: CGPoint) -> CGPoint {
        let distance = sqrt(pow((startPoint.x - endPoint.x), 2) + pow((startPoint.y - endPoint.y), 2))
        let node_Y = padding*(startPoint.y - endPoint.y)/distance + endPoint.y
        let node_X = padding*(startPoint.x - endPoint.x)/distance + endPoint.x
        let node_point = CGPoint(x: node_X, y: node_Y)
        return node_point
    }
    
    /// 缩放变换贝塞尔曲线以适应给定的大小
    /// - Parameters:
    ///   - path: UIBezierPath
    ///   - size: 大小
    static func scale(path: UIBezierPath, to size: Double) -> CGAffineTransform {
        let scale_w = CGFloat(size)/path.bounds.width
        let scale_h = CGFloat(size)/path.bounds.height
        let factor = min(scale_w, scale_h)
        
        let center = CGPoint(x: path.bounds.midX, y: path.bounds.midY)
        var xform  = CGAffineTransform.identity
        
        xform = xform.concatenating(CGAffineTransform(translationX: -center.x, y: -center.y))
        xform = xform.concatenating(CGAffineTransform(scaleX: factor, y: factor))
        xform = xform.concatenating(CGAffineTransform(translationX: center.x, y: center.y))
        return xform
    }
    
    static func sin_degree(_ degree: Double) -> Double {
        return sin(degree/180*Double.pi)
    }
    
    static func cos_degree(_ degree: Double) -> Double {
        return cos(degree/180*Double.pi)
    }
}
