# HourAndMinutePicker
Hour and minute picker for SwiftUI and UIKit.

When we think that "I want to use a picker with multi-columns and fixed labels", it is very tedious and takes longer implementation time than we thought. This repository solves a part of the problem for hour and minute.

![Simulator Screen Recording - iPhone 15 Pro - 2024-05-18 at 09 58 13](https://github.com/yosshi4486/HourAndMinutePicker/assets/9734876/23252c2c-b794-4de2-ac3f-61253626ae42)

# Usage
If you want to change `minuteInterval` and `maximumHour`, declear them as `@State` property. Changes of the states will trigger `HourAndMinutePicker.updateUIView` method to apply the changes to an internal UIView.

```swift
struct MyView: View {
  @State private var hour: Int = 1
  @State private var minute: Int = 0
  @State private var maximumHour: Int  = 23
  @State private var minuteInterval: Int = 5

  var body: some View {
    HourAndMinutePicker(hour: $hour, minute: $minute, maximumHour: maximumHour, minuteInterval: minuteInterval)
  }

}
```

## Installation
via Swift Package Manager

1. Xcode Package Dependencies
2. Add Button
3. Enter the repository URL: https://github.com/yosshi4486/HourAndMinutePicker
