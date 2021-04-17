//
//  ProjectTracker_TDD_ONTests.swift
//  ProjectTracker_TDD_ONTests
//
//  Created by Ihor Savynskyi on 17.04.2021.
//

import XCTest
@testable import ProjectTracker_TDD_ON

class DefaultProjectProgressPresenterTests: XCTestCase {


    func test_whenViewDidLoadCalled_thenViewConfigurationMethodsCalled() {
        let viewMock = ProjectProgressViewMock()
        let sut = DefaultProjectProgressPresenter(view: viewMock)
        
        XCTAssertEqual(viewMock.updateTitleCallsHistory.count, 0)
        XCTAssertEqual(viewMock.updateSliderCallsHistory.count, 0)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.count, 0)

        sut.viewDidLoad()
        
        XCTAssertEqual(viewMock.updateTitleCallsHistory.count, 1)
        XCTAssertEqual(viewMock.updateTitleCallsHistory.first, "Awesome project progress")

        XCTAssertEqual(viewMock.updateSliderCallsHistory.count, 1)
        XCTAssertEqual(viewMock.updateSliderCallsHistory.first, 0)
        
        XCTAssertEqual(viewMock.updateStatusCallsHistory.count, 1)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.first?.status, "0% (not started)")
        XCTAssertEqual(viewMock.updateStatusCallsHistory.first?.color, .systemRed)
    }
}
