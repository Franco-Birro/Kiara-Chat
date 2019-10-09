//
//  ViewController.swift
//  Kiara-Chat
//
//  Created by Franco Birro on 29/06/19.
//  Copyright © 2019 Franco Birro. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView


class ChatViewController: MessagesViewController {
    
    var messages: [Message] = []
    var member: Member!
    var watson: Member!
    //let service: Service?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        member = Member(name: "User", color: .blue)
        watson = Member(name: "Kiara", color: .orange)

        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messageInputBar.delegate = self
        messagesCollectionView.messagesDisplayDelegate = self
    }
    
    func sendMessage(mesage: String) {
        let parameters = ["mesage": mesage]
        
        guard let url = URL(string: "https://assistantinsigths.mybluemix.net/mesage") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
           
        if let data = data {
            do {
                if let dict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any?],
                    let output = dict?["output"] as? [String: Any?],
                    let answerArray = output["generic"] as?  [[String: String?]]{
                    
                    let text = answerArray[0]["text"]
                    self.printMessage(mesage: text!!)
                    }
                }
            }
            }.resume()
    }
   
    func printMessage(mesage: String){
       let newMessage = Message(
        member: self.watson,
        text: mesage,
        messageId: UUID().uuidString)
        messages.append(newMessage)
        DispatchQueue.main.async {
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToBottom(animated: true)        }
    }
}

extension ChatViewController: MessagesDataSource {
    func currentSender() -> SenderType {
        return Sender(id: member.name, displayName: member.name)
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    

    func messageForItem(
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) -> MessageType {
        
        return messages[indexPath.section]
    }
    
    func messageTopLabelHeight(
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 12
    }
    
    func messageTopLabelAttributedText(
        for message: MessageType,
        at indexPath: IndexPath) -> NSAttributedString? {
        
        return NSAttributedString(
            string: message.sender.displayName,
            attributes: [.font: UIFont.systemFont(ofSize: 12)])
    }
}

extension ChatViewController: MessagesDisplayDelegate {
    func configureAvatarView(
        _ avatarView: AvatarView,
        for message: MessageType,
        at indexPath: IndexPath,
        in messagesCollectionView: MessagesCollectionView) {
        
        let message = messages[indexPath.section]
        let color = message.member.color
        avatarView.backgroundColor = color
    }
}


extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(
        _ inputBar: InputBarAccessoryView,
        didPressSendButtonWith text: String) {
        
        let newMessage = Message(
            member: member,
            text: text,
            messageId: UUID().uuidString)
        
        
        self.sendMessage(mesage: text)

        
        messages.append(newMessage)
        inputBar.inputTextView.text = ""
        messagesCollectionView.reloadData()
        messagesCollectionView.scrollToBottom(animated: true)
    }
}

extension ChatViewController: MessagesLayoutDelegate {
    func heightForLocation(message: MessageType,
                           at indexPath: IndexPath,
                           with maxWidth: CGFloat,
                           in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 0
    }
}
