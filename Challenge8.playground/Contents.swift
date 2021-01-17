import UIKit

extension UIView {
    
    func bounceOut(duration: Double) {
        UIView.animate(withDuration: duration, animations: {
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        })
    }
}

extension Int {
    func times(times: ()-> Void) {
        for _ in 0...self {
            times()
        }
    }
}

extension Array  where Element: Comparable{
    mutating func remove(item: Element)  {
        if let location = self.firstIndex(of: item) {
            self.remove(at: location)
        }
    }
}
