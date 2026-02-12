//
//  MyRecallAppTests.swift
//  MyRecallAppTests
//
//  Created by Robert Goedman on 12/29/24.
//

import Testing
import Foundation
@testable import MyRecallApp

struct MyRecallAppTests {

    // MARK: - Topic Model Tests
    
    @Test func testTopicInitialization() async throws {
        let topic = Topic("Swift Programming", true, Date(), 0, [])
        
        #expect(topic.title == "Swift Programming")
        #expect(topic.includedInRecall == true)
        #expect(topic.noOfRecallCycles == 0)
        #expect(topic.subTopics?.isEmpty == true)
    }
    
    @Test func testTopicDefaultInitialization() async throws {
        let topic = Topic()
        
        #expect(topic.title == "")
        #expect(topic.includedInRecall == true)
        #expect(topic.noOfRecallCycles == 0)
    }
    
    @Test func testTopicEncodingDecoding() async throws {
        let originalTopic = Topic("Test Topic", true, Date(), 5, [])
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(originalTopic)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decodedTopic = try decoder.decode(Topic.self, from: data)
        
        #expect(decodedTopic.title == originalTopic.title)
        #expect(decodedTopic.includedInRecall == originalTopic.includedInRecall)
        #expect(decodedTopic.noOfRecallCycles == originalTopic.noOfRecallCycles)
    }
    
    // MARK: - SubTopic Model Tests
    
    @Test func testSubTopicInitialization() async throws {
        let topic = Topic("Parent Topic")
        let subTopic = SubTopic("Swift Basics", topic, true, Date(), 0, [], [], SubTopicRecallTimeStamp())
        
        #expect(subTopic.title == "Swift Basics")
        #expect(subTopic.topic?.title == "Parent Topic")
        #expect(subTopic.includedInRecall == true)
        #expect(subTopic.noOfRecallCycles == 0)
    }
    
    @Test func testSubTopicDefaultInitialization() async throws {
        let subTopic = SubTopic()
        
        #expect(subTopic.title == "")
        #expect(subTopic.includedInRecall == true)
        #expect(subTopic.noOfRecallCycles == 0)
    }
    
    @Test func testSubTopicEncodingDecoding() async throws {
        let subTopic = SubTopic("Test SubTopic", nil, true, Date(), 3, [], [], SubTopicRecallTimeStamp())
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(subTopic)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decodedSubTopic = try decoder.decode(SubTopic.self, from: data)
        
        #expect(decodedSubTopic.title == subTopic.title)
        #expect(decodedSubTopic.includedInRecall == subTopic.includedInRecall)
        #expect(decodedSubTopic.noOfRecallCycles == subTopic.noOfRecallCycles)
    }
    
    // MARK: - Question Model Tests
    
    @Test func testQuestionInitialization() async throws {
        let question = Question("What is Swift?", "A programming language", "", true, Date(), 0, nil, nil, [QuestionRecallTimeStamp()])
        
        #expect(question.title == "What is Swift?")
        #expect(question.answer == "A programming language")
        #expect(question.userAnswer == "")
        #expect(question.includedInRecall == true)
        #expect(question.noOfRecallCycles == 0)
    }
    
    @Test func testQuestionDefaultInitialization() async throws {
        let question = Question()
        
        #expect(question.title == "")
        #expect(question.answer == "")
        #expect(question.userAnswer == "")
        #expect(question.includedInRecall == true)
        #expect(question.noOfRecallCycles == 0)
    }
    
    @Test func testQuestionEncodingDecoding() async throws {
        let question = Question("Test Question", "Test Answer", "User Answer", true, Date(), 2, nil, nil, [QuestionRecallTimeStamp()])
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(question)
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decodedQuestion = try decoder.decode(Question.self, from: data)
        
        #expect(decodedQuestion.title == question.title)
        #expect(decodedQuestion.answer == question.answer)
        #expect(decodedQuestion.userAnswer == question.userAnswer)
        #expect(decodedQuestion.includedInRecall == question.includedInRecall)
        #expect(decodedQuestion.noOfRecallCycles == question.noOfRecallCycles)
    }
    
    @Test func testQuestionAnswerComparison() async throws {
        let question = Question("Test", "correct answer", "correct answer")
        
        #expect(question.answer == question.userAnswer)
    }
    
    @Test func testQuestionRecallCycleIncrement() async throws {
        let question = Question("Test", "Answer", "", true, Date(), 0)
        
        #expect(question.noOfRecallCycles == 0)
        
        // Simulate incrementing recall cycles
        question.noOfRecallCycles += 1
        #expect(question.noOfRecallCycles == 1)
    }

}
