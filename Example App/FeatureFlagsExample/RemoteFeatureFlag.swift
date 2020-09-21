// Copyright © Datadog, Inc. All rights reserved.

import Foundation
import SwiftUI
import Combine
import FeatureFlagsController


/// Fake "Remote Feature Flag" illustrating how one can implement a custom feature flag.
///
/// From this, it should be quite easy to integrate a 3rd party service like Firebase Remote Config or Launch Darkly
public struct RemoteToggleFeatureFlag: FeatureFlag {
    
    public init(key: String, group: String? = nil) {
        self.id = "RemoteFeatureFlag_\(key)"
        self.title = key
        self.group = group
    }
    
    public let id: String
    public let title: String
    public let group: String?
    
    public var value: Bool {
        get { true } // Stub
        nonmutating set { }
    }
        
    public var valuePublisher: AnyPublisher<Bool, Never> {
        Empty(completeImmediately: true).eraseToAnyPublisher() // Stub
    }
    
    public var view: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value ? "true" : "false").foregroundColor(.secondary)
        }
    }
}
