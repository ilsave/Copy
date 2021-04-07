//
//  ContactsView.swift
//  ContactBookFinal
//
//  Created by Gushchin Ilya on 31.03.2021.
//

import Foundation
import ContactsUI

protocol ContactsView: class {
    func showContacts(_ contacts: [Contact])
    func showError(_ error: Error)
    
    func showProgress()
    func hideProgress()
}

protocol ContactsViewOutput {
    func viewOpened()
    func contactPressed(_ contact: Contact)
    func newContactAdded(_ contact: ContactsData)
}
