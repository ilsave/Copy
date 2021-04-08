//
//  ContactsRepository.swift
//  ContactBookFinal
//
//  Created by Gushchin Ilya on 31.03.2021.
//

import Foundation
import ContactsUI

struct Contact: Codable {
    let recordId: String
    let firstName: String
    let lastName: String
    let phone: String
    let gifUrl: String?
}

struct ContactsData {
    let firstName: String
    let lastName: String
    let phone: String
    let birthday: Date
}

struct ContactNotification {
    let contact: Contact
    let birthday: Date
}


protocol ContactsRepository {
    
    func getContacts() throws -> [Contact]
    func add(contact: ContactsData) throws
    func delete(contact: Contact) throws
    func update(contact: Contact) throws
}
