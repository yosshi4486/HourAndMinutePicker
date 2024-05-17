//
//  UIHourAndMinutePickerView.swift
//  Created by yosshi4486 on 2024/05/17.
//

import SwiftUI

#if os(iOS)
/// A view that uses a spinning-wheel or slot-machine metaphor to pick a set of hour and minute.
public class UIHourAndMinutePickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
        
    // The value is equal to UIDatePicker font point size.
    public static let pickerItemFontSize: CGFloat = 23.5
    
    /// The data source for the picker view.
    public weak var delegate: UIHourAndMinutePickerViewDelegate?
    
    /// The selected hour value of picker view. The default value is `0`.
    public private(set) var selectedHour: Int = 0
    
    /// The selected minute value of picker view. The default value is `0`
    public private(set) var selectedMinute: Int = 0
    
    /// The maximum hour value of picker view. The default value is `23`.
    public var hourMaximumValue: Int = 23
    
    /// The interval at which the picker should display minutes.
    ///
    /// Use this property to set the interval displayed by the minutes wheel (for example, 15 minutes). The interval value must be evenly divided into 60; if it isn’t, this view raises a runtime error. The default and minimum values are 1; the maximum value is 30.
    public var minuteInterval: Int = 1 {
        willSet {
            precondition(1 <= newValue && newValue <= 30 && (60 % newValue == 0))
        }
    }
    
    /// The picker view that picks a set of hour and minute.
    public var pickerView: UIPickerView!
    
    /*
     Although I don't know reasons, when a component width exceeding a certain threshold is specified, the display in the selected row becomes distorted. The value 130 is the critical magic number that prevents this distortion.
     */
    private let componentWidth: CGFloat = 130
    private var fixedHoursLabel: UILabel!
    private var fixedMinLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Initialize picker view
        pickerView = UIPickerView(frame: frame)
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(pickerView)
        
        NSLayoutConstraint.activate([
            pickerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pickerView.topAnchor.constraint(equalTo: topAnchor),
            pickerView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        // Define constants
        let spacingBetweenComponents: CGFloat = 5
        let spacingAfterLabel: CGFloat = 5
        let labelFontSize = UIFont.preferredFont(forTextStyle: .body).pointSize
        
        // Intialize fixed labels
        fixedHoursLabel = UILabel()
        fixedHoursLabel.font = .boldSystemFont(ofSize: labelFontSize)
        fixedHoursLabel.textColor = .label
        fixedHoursLabel.isAccessibilityElement = false
        fixedHoursLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(fixedHoursLabel)
        NSLayoutConstraint.activate([
            fixedHoursLabel.leadingAnchor.constraint(equalTo: centerXAnchor, constant: -(componentWidth / 2) - (spacingBetweenComponents / 2) + spacingAfterLabel),
            fixedHoursLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        fixedMinLabel = UILabel()
        fixedMinLabel.font = .boldSystemFont(ofSize: labelFontSize)
        fixedMinLabel.textColor = .label
        fixedMinLabel.isAccessibilityElement = false
        fixedMinLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(fixedMinLabel)
        NSLayoutConstraint.activate([
            fixedMinLabel.leadingAnchor.constraint(equalTo: centerXAnchor, constant: (componentWidth / 2) + (spacingBetweenComponents / 2) + spacingAfterLabel),
            fixedMinLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

        updateFixedLabels()
    }
            
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    public override var intrinsicContentSize: CGSize {
        // An intrinsicContenteSize of UIPickerView is w:320, height:216, however; the width is too narrow to place fixed labels. 400 is suitable.
        return CGSize(width: 400, height: 216)
    }
    
    /// Selects a hour of the picker view.
    ///
    /// - Attention:
    /// This method doesn't trigger `delegate.pickerView(_:didSelectHour:minute:)`.
    ///
    /// - Parameters:
    ///   - hour: A hour value from 0 to `hourMaximumValue`.
    ///   - animated: The boolean value indicating whether the change triggers selection animations.
    public func selectHour(_ hour: Int, animated: Bool = false) {
        
        guard hour != selectedHour else {
            return
        }
        
        selectedHour = hour
        
        // This line doesn't trigger `pickerView(_:didSelectRow:inComponent:)`.
        pickerView.selectRow(hour, inComponent: 0, animated: animated)
        
        updateFixedLabels()
    }
    
    /// Selects a minute of the picker view.
    ///
    /// - Attention:
    /// This method doesn't trigger `delegate.pickerView(_:didSelectHour:minute:)`.
    ///
    /// - Parameters:
    ///   - hour: A minute value from 0 to 59.
    ///   - animated: The boolean value indicating whether the change triggers selection animations.
    public func selectMinute(_ minute: Int) {
        
        guard minute != selectedMinute else {
            return
        }
        
        selectedMinute = minute
        
        // This line doesn't trigger `pickerView(_:didSelectRow:inComponent:)`.
        pickerView.selectRow(minute / minuteInterval, inComponent: 1, animated: false)
        
        updateFixedLabels()
    }
    
    // MARK: - Adopting UIPickerViewDataSource
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // Hour column and minute column
        return 2
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            // Including zero
            return hourMaximumValue + 1
            
        case 1:
            return 60 / minuteInterval
            
        default:
            fatalError("Development Failure")
        }
    }
        
    // MARK: - Adopting UIPickerViewDelegate
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        if let labelContainer = view as? LabelContainer {
            labelContainer.text = title(forRow: row, component: component)
            return labelContainer
        }
        
        let labelContainer = LabelContainer()
        labelContainer.text = title(forRow: row, component: component)
        labelContainer.isAccessibilityElement = true
        labelContainer.accessibilityAttributedLabel = accessibilityAttributedLabel(forRow: row, component: component)
        labelContainer.accessibilityValue = nil
        return labelContainer
    }
                
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch component {
        case 0:
            selectedHour = row
            
        case 1:
            selectedMinute = row * minuteInterval
            
        default:
            fatalError("Development Failure")
        }
        
        updateFixedLabels()
        delegate?.pickerView(self, didSelectHour: selectedHour, minute: selectedMinute)
    }
    
    public func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        // 一定上の横幅をコンポーネントに与えると選択行で表示が歪む?現象があり、100なら回避できるため
        return componentWidth
    }
    
    // MARK: - Private Methods
    
    private func title(forRow row: Int, component: Int) -> String {
        
        switch component {
        case 0:
            return String("\(row)")
            
        case 1:
            return String("\(row * minuteInterval)")
            
        default:
            fatalError("Development Failure")
        }

    }
    
    private func accessibilityAttributedLabel(forRow row: Int, component: Int) -> NSAttributedString {
        
        switch component {
        case 0:
            return NSAttributedString(AttributedString(localized: "^[\(row) hour](inflect: true)", bundle: .module, comment: "Picker Label: An accessibilityLabel of the hour component."))
        case 1:
            return NSAttributedString(AttributedString(localized: "^[\(row * minuteInterval) min](inflect: true)", bundle: .module, comment: "Picker Label: An accessibilityLabel of the minute component."))
        default:
            fatalError("Development Failure")
        }

    }
    
    /// Updates fixed labels using Automatic Grammar Agreement APIs.
    ///
    /// - Note: Automatic grammer agreement APIs are always correct than mine.
    private func updateFixedLabels() {
        
        let hourString = String(AttributedString(localized: "^[\(selectedHour) hour](inflect: true)", bundle: .module).inflected().characters).dropFirst(selectedHour.description.count + 1)
        fixedHoursLabel.text = String(hourString)
        
        let minuteString = String(AttributedString(localized: "^[\(selectedMinute) min](inflect: true)", bundle: .module).inflected().characters).dropFirst(selectedMinute.description.count + 1)
        fixedMinLabel.text = String(minuteString)

    }
        
}

// MARK: - Helper View

extension UIHourAndMinutePickerView {
    
    @dynamicMemberLookup private class LabelContainer: UIView {
                        
        let label: UILabel = {
            let view = UILabel()
            view.font = UIFont.monospacedDigitSystemFont(ofSize: UIHourAndMinutePickerView.pickerItemFontSize, weight: .regular)
            view.textColor = .label
            view.textAlignment = .right
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        subscript<U>(dynamicMember keyPath: ReferenceWritableKeyPath<UILabel, U>) -> U {
            get {
                label[keyPath:keyPath]
            }

            set {
                label[keyPath:keyPath] = newValue
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            
            addSubview(label)
            NSLayoutConstraint.activate([
                label.trailingAnchor.constraint(equalTo: centerXAnchor),
                label.leadingAnchor.constraint(equalTo: leadingAnchor),
                label.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])

        }
        
        required init?(coder: NSCoder) {
            fatalError()
        }
        
    }

}

#Preview {
    return UIHourAndMinutePickerView()
}

#endif
