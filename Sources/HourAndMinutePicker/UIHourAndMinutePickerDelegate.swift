//
//  UIHourAndMinutePickerViewDelegate.swift
//  Created by yosshi4486 on 2024/05/17.
//

import Foundation

#if os(iOS)

/// The interface for a picker view’s data source.
public protocol UIHourAndMinutePickerViewDelegate : AnyObject {
    
    /// Called by the picker view when the user selects a row in a component.
    ///
    /// - Parameters:
    ///   - pickerView: An object representing the picker view requesting the data
    ///   - hour:  A user selected hour from 0 to `hourMaximumValue`
    ///   - minute: A user selected minute value from 0 to 59.
    func pickerView(_ pickerView: UIHourAndMinutePickerView, didSelectHour hour: Int, minute: Int)
    
}

#endif
