//
//  ApiService.swift
//  Test_Cours_listUI
//
//  Created by m1 on 17/02/2022.
//

import Foundation

class ApiConfig: Decodable {
    var API_URL: String
    var API_PORT: Int
    var API_TOKEN_KEY: String
    
    private enum CodingKeys: String, CodingKey {
        case API_URL = "apiUrl"
        case API_PORT = "apiPort"
        case API_TOKEN_KEY = "apiTokenKey"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        API_URL = try values.decode(String.self, forKey: .API_URL)
        API_PORT = try values.decode(Int.self, forKey: .API_PORT)
        API_TOKEN_KEY = try values.decode(String.self, forKey: .API_TOKEN_KEY)
    }

    func getURL() -> URL {
        return getURL(appended: "")
    }
    
    func getURL(appended: String) -> URL {
        return URL(string: API_URL + appended)!
    }
    
    static func getApiConfig() -> ApiConfig? {
        let api_config_loadFromFile_result = JSONHelper.loadFomFile(name: "api_config", ext: "json")
        switch api_config_loadFromFile_result {
            case let .success(data):
                let api_config_decode_result: Result<ApiConfig, JSONError> = JSONHelper.decode(data: data)
                switch api_config_decode_result {
                    case let .success(apiConfig):
                        return apiConfig
                    case let .failure(error): print("[APICONFIG] Error: \(error)")
                }
            case let .failure(error): print("[APICONFIG] Error: \(error)")
        }
        
        return nil
    }
}

enum ApiServiceError: Error {
    case ACCESS_DENIED(String)
    case NOT_FOUND(String)
    case INTERNAL_ERROR(String)
    case UNKNOWN(String)
    
    var description: String {
        switch self {
            case .ACCESS_DENIED(let r):
                return "Accès refusé: \(r)"
            case .NOT_FOUND(let r):
                return "Introuvable: \(r)"
            case .INTERNAL_ERROR(let r):
                return "Erreur interne: \(r)"
            case .UNKNOWN(let r):
                return "\(r)"
        }
    }
}

extension CharacterSet {
    static var urlQueryValueAllowed: CharacterSet {
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }
}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}



class ApiService {
    static var config: ApiConfig!
    
    static func post<T: Decodable>(_ t: T.Type, route: String, parameters: [String: Any], onsuccess: @escaping (T) -> Void){
        return post(t, route: route, parameters: parameters, onsuccess: onsuccess, onerror: { (reason, response, error) in
            print("Ignored error : \(reason) \(String(describing: error)) for response \(response)")
        })
    }
    
    static func get<T: Decodable>(_ t: T.Type, route: String, onsuccess: @escaping (T) -> Void){
        return get(t, route: route, onsuccess: onsuccess, onerror: { (reason, response, error) in
            print("Ignored error : \(reason) \(String(describing: error)) for response \(response)")
        })
    }
    
    static func put<T: Decodable>(_ t: T.Type, route: String, parameters: [String: Any], onsuccess: @escaping (T) -> Void){
        return put(t, route: route, parameters: parameters, onsuccess: onsuccess, onerror: { (reason, response, error) in
            print("Ignored error : \(reason) \(String(describing: error)) for response \(response)")
        })
    }
    
    static func delete<T: Decodable>(_ t: T.Type, route: String, parameters: [String: Any], onsuccess: @escaping (T) -> Void, onsuccessText: @escaping (String) -> Void){
        return delete(t, route: route, parameters: parameters, onsuccess: onsuccess, onsuccessText: onsuccessText, onerror: { (reason, response, error) in
            print("Ignored error : \(reason) \(String(describing: error)) for response \(response)")
        })
    }
    
    static func delete<T: Decodable>(_ t: T.Type, route: String, parameters: [String: Any], onsuccess: @escaping (T) -> Void, onsuccessText: @escaping (String) -> Void, onerror: @escaping (String, HTTPURLResponse, Error?) -> Void){
        var request = URLRequest(url: config.getURL(appended: route))
        request.httpMethod = "DELETE"
        request.setValue("Bearer \(config.API_TOKEN_KEY)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        let task = URLSession.shared.uploadTask(with: request, from: body){ (data, response, error) in
            let errorMessage: String = data != nil ? (String(data: data!, encoding: .utf8) ?? "Unknown error") : "Unknown error"
            
            if let error = error {
                onerror(errorMessage, response as! HTTPURLResponse, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                onerror(errorMessage, response as! HTTPURLResponse, nil)
                return
            }
            
            if let data = data {
                if let o = try? JSONDecoder().decode(T.self, from: data){
                    onsuccess(o)
                } else {
                    onsuccessText(String(data: data, encoding: .utf8)!)
                }
            } else {
                onerror(errorMessage, response as! HTTPURLResponse, nil)
            }
        }
        
        task.resume()
    }
    
    static func post<T: Decodable>(_ t: T.Type, route: String, parameters: [String: Any], onsuccess: @escaping (T) -> Void, onerror: @escaping (String, HTTPURLResponse, Error?) -> Void){
        var request = URLRequest(url: config.getURL(appended: route))
        request.httpMethod = "POST"
        request.setValue("Bearer \(config.API_TOKEN_KEY)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        let task = URLSession.shared.uploadTask(with: request, from: body){ (data, response, error) in
            let errorMessage: String = data != nil ? (String(data: data!, encoding: .utf8) ?? "Unknown error") : "Unknown error"
            
            if let error = error {
                onerror(errorMessage, response as! HTTPURLResponse, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                onerror(errorMessage, response as! HTTPURLResponse, nil)
                return
            }
            
            if let data = data {
                if let o = try? JSONDecoder().decode(T.self, from: data){
                    onsuccess(o)
                    return
                }
            }
            
            onerror(errorMessage, response as! HTTPURLResponse, nil)
        }
        
        task.resume()
    }
    
    static func put<T: Decodable>(_ t: T.Type, route: String, parameters: [String: Any], onsuccess: @escaping (T) -> Void, onerror: @escaping (String, HTTPURLResponse, Error?) -> Void){
        var request = URLRequest(url: config.getURL(appended: route))
        request.httpMethod = "PUT"
        request.setValue("Bearer \(config.API_TOKEN_KEY)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = try! JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        let task = URLSession.shared.uploadTask(with: request, from: body){ (data, response, error) in
            let errorMessage: String = data != nil ? (String(data: data!, encoding: .utf8) ?? "Unknown error") : "Unknown error"
            
            if let error = error {
                onerror(errorMessage, response as! HTTPURLResponse, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                onerror(errorMessage, response as! HTTPURLResponse, nil)
                return
            }
            
            
            if let data = data {
                if let o = try? JSONDecoder().decode(T.self, from: data){
                    onsuccess(o)
                    return
                }
            }
            
            onerror(errorMessage, response as! HTTPURLResponse, nil)
        }
        
        task.resume()
    }
    
    
    static func get<T: Decodable>(_ t: T.Type, route: String, onsuccess: @escaping (T) -> Void, onerror: @escaping (String, HTTPURLResponse, Error?) -> Void){
        var request = URLRequest(url: config.getURL(appended: route))
        request.httpMethod = "GET"
        request.addValue("Bearer \(config.API_TOKEN_KEY)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        DispatchQueue.main.async {
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                let errorMessage: String = data != nil ? (String(data: data!, encoding: .utf8) ?? "Unknown error") : "Unknown error"
                
                if let error = error {
                    onerror(errorMessage, response as! HTTPURLResponse, error)
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    onerror(errorMessage, response as! HTTPURLResponse, nil)
                    return
                }
                
                if let data = data, let o = try? JSONDecoder().decode(T.self, from: data){
                    onsuccess(o)
                    return
                }
                
                onerror(errorMessage, response as! HTTPURLResponse, nil)
            })
        
            task.resume()
        }
    }
}
