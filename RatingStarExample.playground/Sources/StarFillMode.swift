import Foundation
import UIKit

/// 五角星进度显示类型
///
/// - full: 整个五角星
/// - half: 半个五角星
/// - precise: 任意进度
public enum StarFillMode: Int {
    case full = 0
    case half = 1
    case precise = 2
}
