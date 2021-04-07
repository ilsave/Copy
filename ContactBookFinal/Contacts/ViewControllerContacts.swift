//
//  ViewController.swift
//  ContactBookFinal
//
//  Created by Gushchin Ilya on 31.03.2021.
//

import UIKit
import ContactsUI
import UserNotifications
import SwiftyGif

class ViewControllerContacts: UIViewController {
    
 

    var contacts: [Contact] = []
    
    private var output: ContactsViewOutput!

    @IBOutlet var tableViewContacts: UITableView!
    @IBOutlet var indicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let presenter = ContactsPresenter(contactsRepository: Services.factory.getContactsRepository(), callHistoryRepository: Services.factory.getCallHistoryRepository())
        presenter.view = self
        output = presenter
        
        indicator.center = self.view.center
        let nib = UINib(nibName: "ContactTableViewCell", bundle: nil)
        tableViewContacts.register(nib, forCellReuseIdentifier: "ContactTableViewCell")
        
        let nibGif = UINib(nibName: "GifContactTableViewCell", bundle: nil)
        tableViewContacts.register(nibGif, forCellReuseIdentifier: "GifContactTableViewCell")
        
        tableViewContacts.rowHeight = UITableView.automaticDimension
        tableViewContacts.delegate = self
        tableViewContacts.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if contacts.isEmpty{
           output.viewOpened()
        }
    }
    @IBAction func newContactPressed(_ sender: Any) {
        let vc = CNContactViewController(forNewContact: nil)
        vc.delegate = self
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
}

extension ViewControllerContacts: CNContactViewControllerDelegate{
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        guard let contact = contact, let phoneNumber = (contact.phoneNumbers.first?.value)?.stringValue,
              let birthday = contact.birthday!.date
              else {
            return
        }
       
        let userInput = ContactsData.init(firstName: contact.givenName, lastName: contact.familyName, phone: phoneNumber, birthday: birthday)
        
        output.newContactAdded(userInput)
    }
    
    
    func contactViewController(_ viewController: CNContactViewController, shouldPerformDefaultActionFor property: CNContactProperty) -> Bool {
        print(property.contact.birthday as Any)
        return true
    }
    
}

extension ViewControllerContacts: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let path = contacts[indexPath.row].gifUrl {
            let cell = tableView.dequeueReusableCell(withIdentifier: "GifContactTableViewCell", for: indexPath)
            as! GifContactTableViewCell
            
            let url = URL(string: path)
            let loader = UIActivityIndicatorView(style: .white)
            cell.imageGifView.setGifFromURL(url!, customLoader: loader)
            cell.phoneLabel?.text = contacts[indexPath.row].phone
            cell.nameLabel?.text = contacts[indexPath.row].firstName
            cell.surnameLabel?.text = contacts[indexPath.row].lastName
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactTableViewCell", for: indexPath)
        as! ContactTableViewCell
        cell.emailLabel?.text = contacts[indexPath.row].phone
        cell.nameLabel?.text = contacts[indexPath.row].firstName
        cell.surNameLabel?.text = contacts[indexPath.row].lastName
        
        let tapGesture = MyTapGesture(target: self,  action: #selector(onTap))
        tapGesture.customCirle = cell.customCirle
          cell.customCirle.addGestureRecognizer(tapGesture)
        
        return cell
    }
    
    @objc func onTap(sender : MyTapGesture) {
        let countScale: CGFloat = 1.9
        let duration = 1.0
        let delay: TimeInterval = 0
        
        let screenRect = UIScreen.main.bounds
        let scale = Int(screenRect.size.width / sender.customCirle.frame.width * countScale)
        
        UIView.animate(withDuration: duration, delay: delay,
        animations: {
            sender.customCirle.transform = self.view.transform.scaledBy(x: CGFloat(scale), y: CGFloat(scale))
            sender.customCirle.transform = CGAffineTransform(scaleX: CGFloat(scale), y: CGFloat(scale)) }
       )
    }
}

class MyTapGesture: UITapGestureRecognizer {
    var customCirle: InitialsCustomView!
}

extension ViewControllerContacts: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        output.contactPressed(contacts[indexPath.row])
    }
}

extension ViewControllerContacts: ContactsView {
    func showContacts(_ contacts: [Contact]) {
        self.contacts = contacts
        tableViewContacts.reloadData()
    }

    func showProgress() {
        tableViewContacts.isHidden = true
        indicator.startAnimating()
    }
    
    func hideProgress() {
        indicator.stopAnimating()
        tableViewContacts.isHidden = false
    }
    
    func showError(_ error: Error) {
        let alert = UIAlertController(title: "We got error", message: "Something went wrong!", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Nothing special as usual", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}



