# HalfCircleProgress

How To Use: 

https://github.com/omartall/HalfCircleProgress/assets/63508919/a3009318-2ce4-4e0a-904b-9f7f963019d4

```swift
import UIKit
import HalfCircleProgress

class ViewController: UIViewController {
    
    let progressView = HalfCircleContainer(frame: CGRect(x: 50, y: 50, width: 152, height: 76))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(progressView)
    }
    
    func updateProgress() {
        progressView.updateProgress(percent: 0.4)
    }
}
```
