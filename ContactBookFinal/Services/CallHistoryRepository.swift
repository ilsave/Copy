//
//  CallHistoryRepository.swift
//  ContactBookFinal
//
//  Created by Gushchin Ilya on 31.03.2021.
//

import Foundation


struct CallRecord {
    let timestamp: String
    let phone: String
}

protocol CallHistoryRepository {
    
    func getHistory() throws -> [CallRecord]
    func add(record: CallRecord) throws
}
