//
//  ProjectProgressViewMock.swift
//  ProjectTracker_TDD_ONTests
//
//  Created by Ihor Savynskyi on 17.04.2021.
//

import Foundation
import UIKit
@testable import ProjectTracker_TDD_ON

class ProjectProgressViewMock: ProjectProgressView {
    
    private(set) var updateTitleCallsHistory: [String] = []
    func updateTitle(_ title: String) {
        updateTitleCallsHistory.append(title)
    }
    
    private(set) var updateSliderCallsHistory: [Float] = []
    func updateSlider(_ value: Float) {
        updateSliderCallsHistory.append(value)
    }
    
    private(set) var updateStatusCallsHistory: [(status: String, color: UIColor)] = []
    func updateStatus(_ status: String, color: UIColor) {
        updateStatusCallsHistory.append((status: status, color: color))
    }
}
