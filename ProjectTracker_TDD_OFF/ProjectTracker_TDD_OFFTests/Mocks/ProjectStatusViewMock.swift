//
//  ProjectStatusViewMock.swift
//  ProjectTracker_TDD_OFFTests
//
//  Created by Ihor Savynskyi on 17.04.2021.
//

import Foundation
import UIKit
@testable import ProjectTracker_TDD_OFF

class ProjectStatusViewMock: ProjectStatusView {
    
    private(set) var setTitleCallsHistory: [String] = []
    func setTitle(_ title: String) {
        setTitleCallsHistory.append(title)
    }
    
    private(set) var configureProgressAllowedRangeCallsHistory: [ClosedRange<Float>] = []
    func configureProgressAllowedRange(_ range: ClosedRange<Float>) {
        configureProgressAllowedRangeCallsHistory.append(range)
    }
    
    private(set) var setProjectProgressCallsHistory: [Float] = []
    func setProjectProgress(_ value: Float) {
        setProjectProgressCallsHistory.append(value)
    }
    
    private(set) var setStatusCallsHistory: [(status: String, color: UIColor)] = []
    func setStatus(_ status: String, color: UIColor) {
        setStatusCallsHistory.append((status: status, color: color))
    }
}
