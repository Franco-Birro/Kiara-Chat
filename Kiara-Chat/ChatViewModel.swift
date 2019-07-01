//
//  ChatViewModel.swift
//  Kiara-Chat
//
//  Created by Franco Birro on 30/06/19.
//  Copyright © 2019 Franco Birro. All rights reserved.
//

import Foundation


class service {

func sendMessage() {
        let url = URL(string: "assistantinsigths.mybluemix.net/mesage")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("error: \(error)")
            } else {
                if let response = response as? HTTPURLResponse {
                    print("statusCode: \(response.statusCode)")
                }
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    print("data: \(dataString)")
                }
            }
        }
        task.resume()
    }
}
