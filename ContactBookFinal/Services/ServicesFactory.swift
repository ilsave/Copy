//
//  ServicesFactory.swift
//  ContactBookFinal
//
//  Created by Gushchin Ilya on 31.03.2021.
//

import Foundation

protocol ServicesFactory {
    func getContactsRepository() -> ContactsRepository
    func getCallHistoryRepository() -> CallHistoryRepository
}

enum Services {
    static var factory: ServicesFactory!
}
