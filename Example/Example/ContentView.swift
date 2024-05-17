//
//  ContentView.swift
//  Example
//
//  Created by 山田良治 on 2024/05/17.
//

import SwiftUI
import HourAndMinutePicker

let value = String(localized: "Sample Project")

struct ContentView: View {
    @State private var hour: Int = 0
    @State private var minute: Int = 0
    
    var body: some View {
        HourAndMinutePicker(hour: $hour, minute: $minute)
    }
    
}

// .environment(\.locale) doesn't affect to Preview.
// I guess the reason is UIViewRepresentable.

// You can check localizations by:
// Edit Scheme... > Options > App Language > {Select Supported Language}

// Swift Package provide a localization only if a host app declears matched language and has not-empty localization file.
#Preview {
    ContentView()
}
