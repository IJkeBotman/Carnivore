/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {
    
    @IBOutlet var timer: WKInterfaceTimer!
    @IBOutlet var weightLabel: WKInterfaceLabel!
    @IBOutlet var cookLabel: WKInterfaceLabel!
    @IBOutlet var timerButton: WKInterfaceButton!
    
    var ounces = 16
    var cookTemp = MeatTemperature.medium
    var timerRunning = false
    var usingMetric = false
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        updateConfiguration()
        
    }
    
    override func interfaceOffsetDidScrollToTop() {
        print("User scrolled to top")
    }
    
    override func interfaceDidScrollToTop() {
        print("User went to top by tapping status bar")
    }
    
    override func interfaceOffsetDidScrollToBottom() {
        print("User scrolled to bottom")
    }
    
    func updateConfiguration() {
        cookLabel.setText(cookTemp.stringValue)
        
        var weight = ounces
        var unit = "oz"
        
        if usingMetric {
            let grams = Double(ounces) * 28.3495
            weight = Int(grams)
            unit = "gr"
        }
        weightLabel.setText("Weight: \(weight) \(unit)")
    }
    
    @IBAction func onTimerButton() {
        if timerRunning {
            timer.stop()
            timerButton.setTitle("Start Timer")
        } else {
            let time = cookTemp.cookTimeForOunces(ounces)
            timer.setDate(Date(timeIntervalSinceNow: time))
            timer.start()
            timerButton.setTitle("Stop Timer")
        }
        timerRunning = !timerRunning
        scroll(to: timer, at: .top, animated: true)
    }
    
    @IBAction func onMinusButton() {
        ounces -= 1
        updateConfiguration()
    }
    
    @IBAction func onPlusButton() {
        ounces += 1
        updateConfiguration()
    }
    
    @IBAction func onTempChange(_ value: Float) {
        if let temp = MeatTemperature(rawValue: Int(value)) {
            cookTemp = temp
            updateConfiguration()
        }
    }
    
    @IBAction func onMetricChanged(_ value: Bool) {
        usingMetric = value
        updateConfiguration()
    }
    
}
