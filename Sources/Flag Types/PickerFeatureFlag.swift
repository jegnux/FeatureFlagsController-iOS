/*
 * Unless explicitly stated otherwise all files in this repository are licensed under the MIT License.
 * This product includes software developed at Datadog (https://www.datadoghq.com/).
 * Copyright 2020 Datadog, Inc.
 */

import Foundation
import SwiftUI
import Combine

public struct PickerFeatureFlag<Value, Style: PickerStyle>: FeatureFlag where
    Value: CaseIterable & Hashable & RawRepresentable,
    Value.RawValue == String,
    Value.AllCases: RandomAccessCollection {
    
    public init(title: String, defaultValue: Value, group: String? = nil, userDefaults: UserDefaults = .featureFlags, style: Style) {
        self.title = title
        self.defaultValue = defaultValue
        self.group = group
        self.userDefaults = userDefaults
        self.style = style
    }
    
    private let style: Style
    public let title: String
    public let defaultValue: Value
    public let group: String?
    private let userDefaults: UserDefaults
    
    public var value: Value {
        get {
            guard let rawValue = userDefaults.object(forKey: id) as? String,
                  let value = Value.init(rawValue: rawValue)
            else {
                return defaultValue
            }
            return value
        }
        nonmutating set {
            userDefaults.set(newValue.rawValue, forKey: id)
        }
    }
       
    public var valuePublisher: AnyPublisher<Value, Never> {
        NotificationCenter.default
            .publisher(for: UserDefaults.didChangeNotification)
            .map { _ in self.value }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    public var view: some View {
        HStack(spacing: 16) {
            Text(title)
            Spacer()
            Picker(selection: binding, label: Text("")) {
                ForEach(Value.allCases, id: \.hashValue) { value in
                    value.makeView()
                }
            }
            .pickerStyle(style)
        }
    }
}

extension PickerFeatureFlag where Style == DefaultPickerStyle {
    public init(title: String, defaultValue: Value, group: String? = nil) {
        self = PickerFeatureFlag(title: title, defaultValue: defaultValue, group: group, style: DefaultPickerStyle())
    }
}

extension RawRepresentable where Self: Hashable, RawValue == String {
    fileprivate func makeView() -> some View {
        Text(String(describing: self)).tag(self)
    }
}
