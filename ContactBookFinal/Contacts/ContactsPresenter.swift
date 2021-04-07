//
//  Contacts-.swift
//  ContactBookFinal
//
//  Created by Gushchin Ilya on 31.03.2021.
//

import Foundation
import ContactsUI

class ContactsPresenter {
    
    private var contactsRepository: ContactsRepository!
    private var callHistoryRepository: CallHistoryRepository!
    weak var view: ContactsView?
    
    init(contactsRepository: ContactsRepository, callHistoryRepository: CallHistoryRepository) {
        self.contactsRepository = contactsRepository
        self.callHistoryRepository = callHistoryRepository
    }
}

extension ContactsPresenter: ContactsViewOutput {
    func viewOpened() {
        view?.showProgress()
        async { [weak self] in
            
            guard let self = self else {
                return
            }
            
            defer {
                asyncMain {
                    self.view?.hideProgress()
                }
            }
            
            do {
                let contacts = try self.contactsRepository.getContacts()
                asyncMain {
                    self.view?.showContacts(contacts)
                }
            } catch {
                asyncMain {
                    self.view?.showError(error)
                }
            }
        }
    }
    
    
    func contactPressed(_ contact: Contact) {
        makeCall(to: contact)
    }
    
    func makeCall(to contact: Contact) {
        
        do {
            let now = Date()
            let formatter = DateFormatter()
            formatter.timeZone = TimeZone.current
            formatter.dateFormat = "HH:mm"
            let dateString = formatter.string(from: now)
            try callHistoryRepository.add(record: CallRecord(
                timestamp: dateString,
                phone: contact.phone))
        } catch {
            view?.showError(error)
        }
    }
    
    func newContactAdded(_ contact: ContactsData) {
        do {
            try contactsRepository.add(contact: contact)
        } catch {
            view?.showError(error)
        }
    }
    
}
