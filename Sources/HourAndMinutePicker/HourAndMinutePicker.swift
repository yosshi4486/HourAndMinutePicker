//
//  HourAndMinutePicker.swift
//  Created by yosshi4486 on 2024/05/17.
//

import SwiftUI

/// A control for selecting a set of hour and minute.
public struct HourAndMinutePicker: UIViewRepresentable {
    
    /// The binding hour value.
    @Binding public var hour: Int
    
    /// The binding minute value.
    @Binding public var minute: Int
    
    /// The maximum hour value of picker view. The default value is `23`.
    public var hourMaximumValue: Int = 23
    
    /// The interval at which the picker should display minutes.
    ///
    /// Use this property to set the interval displayed by the minutes wheel (for example, 15 minutes). The interval value must be evenly divided into 60; if it isn’t, this view raises a runtime error. The default and minimum values are 1; the maximum value is 30.
    public var minuteInterval: Int = 1

    public func makeUIView(context: Context) -> UIHourAndMinutePickerView {
        let view = UIHourAndMinutePickerView()
        view.delegate = context.coordinator
        view.hourMaximumValue = self.hourMaximumValue
        view.minuteInterval = self.minuteInterval
        return view
    }
    
    public func updateUIView(_ uiView: UIHourAndMinutePickerView, context: Context) {
        uiView.selectHour(hour)
        uiView.selectMinute(minute)
    }
    
    public func makeCoordinator() -> Coordinator {
        Coordinator(hour: $hour, minute: $minute, hourMaximumValue: hourMaximumValue, minuteInterval: minuteInterval)
    }
    
    public func sizeThatFits(_ proposal: ProposedViewSize, uiView: UIHourAndMinutePickerView, context: Context) -> CGSize? {
        
        let width: CGFloat = {
            if let proposalWidth = proposal.width {
                return max(proposalWidth, uiView.intrinsicContentSize.width)
            } else {
                return uiView.intrinsicContentSize.width
            }
        }()
        
        return .init(width: width, height: uiView.intrinsicContentSize.height)
    }
    
    public class Coordinator: NSObject, UIHourAndMinutePickerViewDelegate {
        var hour: Binding<Int>
        var minute: Binding<Int>
        var hourMaximumValue: Int
        var minuteInterval: Int
        
        init(hour: Binding<Int>, minute: Binding<Int>, hourMaximumValue: Int, minuteInterval: Int) {
            self.hour = hour
            self.minute = minute
            self.hourMaximumValue = hourMaximumValue
            self.minuteInterval = minuteInterval
        }
        
        public func pickerView(_ pickerView: UIHourAndMinutePickerView, didSelectHour hour: Int, minute: Int) {
            self.hour.wrappedValue = hour
            self.minute.wrappedValue = minute
        }
        
    }
    
    
}

#Preview {
    @State var hour: Int = 1
    @State var minute: Int = 0
    return HourAndMinutePicker(hour: $hour, minute: $minute)
}
