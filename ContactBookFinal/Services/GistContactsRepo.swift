//
//  GistContactRepo.swift
//  ContactBookFinal
//
//  Created by Gushchin Ilya on 31.03.2021.
//

import Foundation
import ContactsUI

class GistContactsRepo: ContactsRepository {
    
    
    private let url: URL
    private let decoder: JSONDecoder
    private let databaseName = "Database.json"
    
    private var contacts: [Contact] = []
    
    
    
    let secondsToWaitForResponse: Int = 30
    
    init(url: URL) {
        self.url = url
        decoder = JSONDecoder()
    }
    
    func getContacts() throws -> [Contact] {
        
        guard let docDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                else { return []}
        
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        var fileURL: URL? = nil
        let innerUrl = NSURL(fileURLWithPath: path)
        guard let pathComponent = innerUrl.appendingPathComponent(databaseName) else {
            return []
        }
        let filePath = pathComponent.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            fileURL = pathComponent
            let data = try Data(contentsOf: fileURL!)
            let jsonDecoder = JSONDecoder()
            let items = try jsonDecoder.decode([Contact].self, from: data)
            return items
        } else {
            fileURL = URL(fileURLWithPath: databaseName, relativeTo: docDirectoryURL)
            let jsonEncoder = JSONEncoder()
            let contactsDb = try getContactsFromApi()
            let jsonCodedData2 = try jsonEncoder.encode(contactsDb)
            try jsonCodedData2.write(to: fileURL!)
            return contactsDb
        }
    }
    
    
    func getContactsFromApi() throws -> [Contact] {
        let sem = DispatchSemaphore(value: 0)
        let request = URLRequest(url: url)
        
        var resultError: Error? = nil
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            defer {
                sem.signal()
            }
            
            guard error == nil else {
                resultError = error
                return
            }
            
            guard let data = data else {
                return
            }
            
            struct ContactsResponse: Decodable {
                let firstname: String
                let lastname: String
                let phone: String
                let email: String
                let photoUrl: String?
            }
            
            do {
                print(data.count)
                self.contacts = try self.decoder.decode([ContactsResponse].self, from: data).map {
                    Contact(recordId: UUID().uuidString,
                            firstName: $0.firstname,
                            lastName: $0.lastname,
                            phone: $0.phone,
                            gifUrl: $0.photoUrl)
                }
            } catch {
                resultError = error
            }
        }
        task.resume()
        let time: DispatchTime = .now() + .seconds(secondsToWaitForResponse)
                if (sem.wait(timeout: time) == .timedOut) {
                    print("We have been waiting for too long time mate")
                    return []
                }
        
        sem.wait()
        
        
        if let error = resultError {
            throw error
        }
        
        return contacts
    }
    
    func add(contact: ContactsData) throws {
        guard let docDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
                else { return }
        let jsonDecoder = JSONDecoder()
        let jsonEncoder = JSONEncoder()
        let innerUrl = URL(fileURLWithPath: docDirectoryURL.absoluteString)
        let pathComponent = innerUrl.appendingPathComponent(databaseName)
        let data = try Data(contentsOf: pathComponent)
        var items = try jsonDecoder.decode([Contact].self, from: data)
        
        let newContact = Contact.init(recordId: UUID().uuidString, firstName: contact.firstName, lastName: contact.lastName, phone: contact.phone, gifUrl: nil)
        
        items.append(newContact)
        
        let jsonCodedData = try jsonEncoder.encode(items)
        try jsonCodedData.write(to: pathComponent)
        
        let notificationContact = ContactNotification.init(contact: newContact, birthday: contact.birthday)
        createNotification(contactNotification: notificationContact)
    }
   
    func createNotification(contactNotification: ContactNotification) {
        let birthday = contactNotification.birthday
        
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound]
        center.requestAuthorization(options: options) { (granted, error) in
            if !granted {
                print("Something went wrong \(error)")
            }
        }
        let content = UNMutableNotificationContent()
        content.title = "Don't forget!"
        content.body = "Its \(contactNotification.contact.firstName) BirthDay today! Its perfect time to make a call and celebrate!:)))"
        content.sound = UNNotificationSound.default
        content.badge = 1
        print(birthday)
        var components = Calendar.current.dateComponents([.month, .day], from: birthday)
        
        components.hour = 12
        components.minute = 0
        components.second = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        
        
        let request = UNNotificationRequest(identifier: contactNotification.contact.recordId, content: content, trigger: trigger)
        
        center.add(request, withCompletionHandler: { (error) in
            if let error = error {
                print(error)
            }
        })
    }
    
    
    func delete(contact: Contact) throws {
        fatalError("unimplemented")
    }
    
    func update(contact: Contact) throws {
        fatalError("unimplemented")
    }
}
