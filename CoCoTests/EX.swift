//
//  Things.swift
//  CoCoTests
//
//  Created by Henry on 7/3/25.
//

import Combine
import Foundation

// MARK: - 실제 코드에서 구현하는 프로토콜

protocol MessageSending {
    func send(_ message: Message) async throws
}

import Observation

@Observable
final class SendMessageViewModel {
    // MARK: - 바인딩이 필요한 경우 private(set)이 아닌 접근가능한 프로퍼티로 변경해야함.

    // 현재 입력 중인 메시지(도메인 객체)
    private(set) var currentMessage: Message = .init(content: "")
    // 메시지 전송 중 여부
    private(set) var isSending: Bool = false
    // 에러 메시지
    private(set) var errorMessage: String?
    // 전송된 메시지 목록 (옵션)
    private(set) var sentMessages: [Message] = []

    private let sender: MessageSending

    init(sender: MessageSending) {
        self.sender = sender
    }

    // 메시지 입력 메서드
    func updateMessageContent(_ content: String) {
        currentMessage = Message(content: content)
    }

    // 메시지 전송 메서드
    func send() async {
        guard currentMessage.isValid, !isSending else { return }
        isSending = true
        errorMessage = nil
        let messageToSend = currentMessage

        // 별도의 Task 블록 없이 직접 비동기 작업 수행
        do {
            try await sender.send(messageToSend)
            sentMessages.append(messageToSend)
            currentMessage = Message(content: "")
        } catch {
            errorMessage = error.localizedDescription
        }
        isSending = false
    }

    var isSendButtonDisabled: Bool {
        !currentMessage.isValid || isSending
    }

    var buttonTitle: String {
        isSending ? "Sending..." : "Send"
    }
}

final class MessageSenderMock: MessageSending {
    // 외부 직접접근 제한
    private(set) var sentMessages: [Message] = []
    var shouldThrowError: Bool = false

    func send(_ message: Message) async throws {
        if shouldThrowError {
            /// NSError 뭔지 모름.
            /// domain    에러의 범주(문자열, 예: "NSURLErrorDomain")
            /// code    에러 코드(정수)
            /// userInfo    추가 정보(딕셔너리, 예: 설명, 원인 등)
            /// 네트워크, 파일 입출력 등 시스템 API 호출 시: 많은 Foundation API가 NSError를 반환하거나 NSError 포인터를 인자로 받습니다.
            /// 에러 메시지 사용자에게 표시: error.localizedDescription을 통해 사용자에게 친절한 에러 메시지를 제공할 수 있습니다.
            /// Objective-C 기반 라이브러리와 연동: SwiftUI 프로젝트에서 Objective-C 라이브러리 사용 시 NSError가 필수적입니다.
            throw NSError(domain: "Test", code: 1, userInfo: [NSLocalizedDescriptionKey: "Send failed"])
        }
        sentMessages.append(message)
    }
}

@testable import CoCo
import Testing

// MARK: - SUT: SendMessageViewModel

// 테스트 구조화(@Suite): 기능별로 테스트를 그룹화하여 가독성과 유지보수성을 높입니다.
@Suite("SendMessageViewModel 테스트")
struct SendMessageViewModelTests {
    // MARK: - GIVEN: 초기 상태, WHEN/THEN: ViewModel 생성 직후 상태 검증

    // MARK: - Test Doubles & Factories

    /// 테스트 대상(SUT)과 Mock 객체를 생성하는 팩토리 메서드
    /// 셋업 코드 분리 (SUT Factory): 반복되는 SUT(System Under Test, 테스트 대상 시스템) 생성 코드를 팩토리 메서드로 분리하여 중복을 제거합니다.
    private func makeSUT(
        sender: MessageSending = MessageSenderMock()
    ) -> (sut: SendMessageViewModel, mockSender: MessageSenderMock) {
        // 테스트에서는 항상 MessageSenderMock를 사용한다고 가정합니다.
        guard let mock = sender as? MessageSenderMock else {
            fatalError("테스트에는 MessageSenderMock만 사용해야 합니다.")
        }
        let sut = SendMessageViewModel(sender: mock)
        return (sut, mock)
    }

    // MARK: - Test Suites

    @Suite("1. 초기 상태 검증")
    struct InitializationTests {
        @Test("ViewModel 생성 직후, 모든 프로퍼티는 기본값으로 초기화되어야 한다.")
        func testInitialState() {
            // GIVEN: SUT 생성
            let (sut, _) = SendMessageViewModelTests().makeSUT()

            // THEN: 초기 상태 검증
            #expect(sut.currentMessage.content.isEmpty, "초기 메시지 내용은 비어있어야 합니다.")
            #expect(sut.isSending == false, "초기 'isSending' 상태는 false여야 합니다.")
            #expect(sut.isSendButtonDisabled == true, "초기 버튼 상태는 비활성화여야 합니다.")
            #expect(sut.buttonTitle == "Send", "초기 버튼 타이틀은 'Send'여야 합니다.")
            #expect(sut.errorMessage == nil, "초기 에러 메시지는 nil이어야 합니다.")
            #expect(sut.sentMessages.isEmpty, "초기 전송된 메시지 목록은 비어있어야 합니다.")
        }
    }

    @Suite("2. 메시지 입력 로직 검증")
    struct MessageInputValidationTests {
        @Test("유효한 텍스트를 입력하면, 전송 버튼이 활성화되어야 한다.")
        func testValidInputEnablesSendButton() {
            // GIVEN
            let (sut, _) = SendMessageViewModelTests().makeSUT()

            // WHEN
            sut.updateMessageContent("유효한 메시지")

            // THEN
            #expect(sut.isSendButtonDisabled == false)
        }

        @Test(
            "유효하지 않은 텍스트(공백, 빈 문자열)를 입력하면, 전송 버튼이 비활성화되어야 한다.",
            arguments: [
                (description: "빈 문자열", input: ""),
                (description: "공백만 있는 문자열", input: "   "),
                (description: "개행/탭 문자열", input: "\n\t")
            ]
        )
        func testInvalidInputDisablesSendButton(argument: (description: String, input: String)) throws {
            // GIVEN
            let (sut, _) = SendMessageViewModelTests().makeSUT()
            // 먼저 버튼을 활성화시켜 상태 변화를 명확히 확인
            sut.updateMessageContent("유효한 메시지")
            try #require(sut.isSendButtonDisabled == false, "테스트 전제조건: 버튼이 활성화되어 있어야 함")

            // WHEN
            sut.updateMessageContent(argument.input)

            // THEN
            #expect(sut.isSendButtonDisabled == true, "입력값 '\(argument.input)'의 경우 버튼이 비활성화되어야 합니다.")
        }
    }

    @Suite("3. 메시지 전송 로직 검증")
    struct MessageSendingLogicTests {
        @Test("메시지 전송에 성공하면, 상태가 올바르게 초기화되고 메시지가 기록되어야 한다.")
        func testSuccessfulSendingResetsState() async throws {
            // GIVEN
            let (sut, mockSender) = SendMessageViewModelTests().makeSUT()
            let messageContent = "테스트 메시지"
            sut.updateMessageContent(messageContent)

            // WHEN: 수정된 async send() 메서드 호출
            await sut.send()

            // THEN
            #expect(mockSender.sentMessages.count == 1)
            #expect(mockSender.sentMessages.first?.content == messageContent)
            #expect(sut.currentMessage.content.isEmpty)
            #expect(sut.isSending == false)
            #expect(sut.isSendButtonDisabled == true)
            #expect(sut.sentMessages.count == 1)
        }

        @Test("메시지 전송에 실패하면, 에러가 기록되고 입력 상태는 유지되어야 한다.")
        func testFailedSendingHandlesErrorAndPreservesState() async throws {
            // GIVEN
            let mockSender = MessageSenderMock()
            mockSender.shouldThrowError = true
            let (sut, _) = SendMessageViewModelTests().makeSUT(sender: mockSender)
            let messageContent = "실패할 메시지"
            sut.updateMessageContent(messageContent)

            // WHEN
            await sut.send()

            // THEN
            #expect(mockSender.sentMessages.isEmpty) // Mock에는 메시지가 전송되지 않음
            #expect(sut.sentMessages.isEmpty) // ViewModel에도 메시지가 기록되지 않음
            #expect(sut.currentMessage.content == messageContent, "실패 시 입력 내용은 유지되어야 합니다.")
            #expect(sut.isSending == false)
            #expect(sut.isSendButtonDisabled == false, "실패 후에는 재시도를 위해 버튼이 활성화되어야 합니다.")
            #expect(sut.errorMessage == "Send failed", "에러 메시지가 올바르게 설정되어야 합니다.")
        }
    }
}
