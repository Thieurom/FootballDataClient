import Combine
import FootballDataClientType
import PilotTestSupport
import XCTest
@testable import FootballDataClient

final class FootballDataClientTests: XCTestCase {

    private var client: FootballDataClient!
    private var urlSession: URLSession!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()

        urlSession = MockingURLProtocol.urlSession()
        client = FootballDataClient(apiToken: "API_TOKEN", urlSession: urlSession)
        cancellables = Set<AnyCancellable>()
    }

    override func tearDown() {
        urlSession = nil
        client = nil
        cancellables = []

        super.tearDown()
    }
}

extension FootballDataClientTests {

    func testFetchCompetition_WhenNetworkFail_ReturnError() {
        MockingURLProtocol.mock = Mock(statusCode: 500, error: URLError(.unknown), data: nil)

        var error: FootballDataError!
        let expecation = expectation(description: #function)

        client.fetchCompetition(competitionId: 123)
            .sink(receiveCompletion: { completion in
                if case let .failure(encounterError) = completion {
                    error = encounterError
                    expecation.fulfill()
                }
            }, receiveValue: { _ in })
            .store(in: &cancellables)

        waitForExpectations(timeout: 1.0)

        XCTAssertEqual(error, .badRequest)
    }
}
