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
    
    func test_whenViewDidLoadCalled_thenProgressSliderRangeConfgurationCalled() {
        let viewMock = ProjectProgressViewMock()
        let sut = DefaultProjectProgressPresenter(view: viewMock)
        
        XCTAssertEqual(viewMock.configureProgressSliderRangeCallsHistory.count, 0)
        
        sut.viewDidLoad()
        
        XCTAssertEqual(viewMock.configureProgressSliderRangeCallsHistory.count, 1)
        XCTAssertEqual(viewMock.configureProgressSliderRangeCallsHistory.first, 0...100)
    }
    
    func test_whenProgressValueChanges_thenProgressStatusUpdated() {
        let viewMock = ProjectProgressViewMock()
        let sut = DefaultProjectProgressPresenter(view: viewMock)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.count, 0)

        sut.progressValueDidChange(0)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.count, 1)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.last?.status, "0% (not started)")
        XCTAssertEqual(viewMock.updateStatusCallsHistory.last?.color, .systemRed)
        
        sut.progressValueDidChange(10)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.count, 2)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.last?.status, "10% (work in progress)")
        XCTAssertEqual(viewMock.updateStatusCallsHistory.last?.color, .systemYellow)

        sut.progressValueDidChange(90)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.count, 3)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.last?.status, "90% (work in progress)")
        XCTAssertEqual(viewMock.updateStatusCallsHistory.last?.color, .systemYellow)
        
        sut.progressValueDidChange(100)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.count, 4)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.last?.status, "100% (completed)")
        XCTAssertEqual(viewMock.updateStatusCallsHistory.last?.color, .systemGreen)
    }
    
    func test_whenProgressValueLessThanLowerBound_thenProgressStatusIsNotStarted() {
        let viewMock = ProjectProgressViewMock()
        let sut = DefaultProjectProgressPresenter(view: viewMock)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.count, 0)

        sut.progressValueDidChange(-10)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.count, 1)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.last?.status, "0% (not started)")
        XCTAssertEqual(viewMock.updateStatusCallsHistory.last?.color, .systemRed)
    }
    
    func test_whenProgressValueGreaterThanUpperBound_thenProgressStatusIsCompleted() {
        let viewMock = ProjectProgressViewMock()
        let sut = DefaultProjectProgressPresenter(view: viewMock)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.count, 0)

        sut.progressValueDidChange(1000)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.count, 1)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.last?.status, "100% (completed)")
        XCTAssertEqual(viewMock.updateStatusCallsHistory.last?.color, .systemGreen)
    }
    
    func test_whenProgressValueHasDecimalPart_thenProgressStatusIsCorrectForNotStartedState() {
        let viewMock = ProjectProgressViewMock()
        let sut = DefaultProjectProgressPresenter(view: viewMock)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.count, 0)
        
        sut.progressValueDidChange(0.1)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.count, 1)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.last?.status, "0% (not started)")
        XCTAssertEqual(viewMock.updateStatusCallsHistory.last?.color, .systemRed)
        
        sut.progressValueDidChange(0.999)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.count, 2)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.last?.status, "0% (not started)")
        XCTAssertEqual(viewMock.updateStatusCallsHistory.last?.color, .systemRed)
    }
    
    func test_whenProgressValueHasDecimalPart_thenProgressStatusIsCorrectForWorkInProgressState() {
        let viewMock = ProjectProgressViewMock()
        let sut = DefaultProjectProgressPresenter(view: viewMock)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.count, 0)
        
        sut.progressValueDidChange(1.001)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.count, 1)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.last?.status, "1% (work in progress)")
        XCTAssertEqual(viewMock.updateStatusCallsHistory.last?.color, .systemYellow)
        
        sut.progressValueDidChange(42.99)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.count, 2)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.last?.status, "42% (work in progress)")
        XCTAssertEqual(viewMock.updateStatusCallsHistory.last?.color, .systemYellow)
        
        sut.progressValueDidChange(99.999)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.count,3)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.last?.status, "99% (work in progress)")
        XCTAssertEqual(viewMock.updateStatusCallsHistory.last?.color, .systemYellow)
    }
    
    func test_whenProgressValueHasDecimalPart_thenProgressStatusIsCorrectForCompletedState() {
        let viewMock = ProjectProgressViewMock()
        let sut = DefaultProjectProgressPresenter(view: viewMock)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.count, 0)
        
        sut.progressValueDidChange(100)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.count, 1)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.last?.status, "100% (completed)")
        XCTAssertEqual(viewMock.updateStatusCallsHistory.last?.color, .systemGreen)
        
        sut.progressValueDidChange(100.01)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.count, 2)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.last?.status, "100% (completed)")
        XCTAssertEqual(viewMock.updateStatusCallsHistory.last?.color, .systemGreen)
        
        sut.progressValueDidChange(1000.999)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.count,3)
        XCTAssertEqual(viewMock.updateStatusCallsHistory.last?.status, "100% (completed)")
        XCTAssertEqual(viewMock.updateStatusCallsHistory.last?.color, .systemGreen)
    }
}
