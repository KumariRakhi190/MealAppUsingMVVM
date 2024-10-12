//
//  APIManager.swift
//  FreeMeal
//
//  Created by Rakhi Kumari on 15/09/24.
//

import Foundation

class APIManager {
    
    static let shared = APIManager()
    
    private init() {}
    
    func apiRequest<T: Decodable>(type: T.Type, url: URL, httpMethodType: MethodType, parameter: [String: Any?]?, _ completion: @escaping(_ success: Bool, _ myResponse: T?, _ msgString: String?, _ httpStatusCode: Int?) -> ()) {
        
        var finalURL = url
        if httpMethodType == .get || httpMethodType == .delete {
            let stringDictionary = Utilities.convertToStringDict(parameter ?? .init())
            var newURLForQuery: String = "\(url)?"
            for (key, value) in stringDictionary {
                newURLForQuery = newURLForQuery + "\(key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")=\(value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")&"
            }
            newURLForQuery.removeLast()
            guard let newURL = URL(string: newURLForQuery) else { return }
            finalURL = newURL
            debugPrint("Generated URL for \(httpMethodType.rawValue) request: \(finalURL)")
        }
        
        var urlRequest = URLRequest(url: finalURL)
        urlRequest.httpMethod = httpMethodType.rawValue
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.addValue(TimeZone.current.identifier, forHTTPHeaderField: "timezone")
        
        if httpMethodType == .post {
            do {
                if let parameter {
                    let jsonData = try JSONSerialization.data(withJSONObject: parameter, options: .prettyPrinted)
                    urlRequest.httpBody = jsonData
                }
            } catch let error {
                print(error.localizedDescription)
            }
        } else {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            if httpMethodType == .put {
                let jsonData = try? JSONSerialization.data(withJSONObject: parameter ?? .init(), options: .prettyPrinted)
                urlRequest.httpBody = jsonData
            }
        }
        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            Loader.hide()
            
            if let error = error {
                debugPrint("Error: " + error.localizedDescription)
                DispatchQueue.main.async {
                    completion(false, nil, "Error: \(error.localizedDescription)", nil)
                }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(false, nil, "Something Went Wrong!", nil)
                }
                return
            }
            
            debugPrint("STATUS CODE FOR \(finalURL) : \(httpResponse.statusCode)")
            
            if (200...209).contains(httpResponse.statusCode) {
                // Success case
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data!)
                    DispatchQueue.main.async {
                        completion(true, decoded, "Success", httpResponse.statusCode)
                    }
                } catch let decodingError {
                    DispatchQueue.main.async {
                        completion(false, nil, "Decoding error", httpResponse.statusCode)
                    }
                    debugPrint(decodingError)
                }
            } else {
                // Failure case
                DispatchQueue.main.async {
                    completion(false, nil, "Failure: Status code \(httpResponse.statusCode)", httpResponse.statusCode)
                }
            }
        }).resume()
    }
}
