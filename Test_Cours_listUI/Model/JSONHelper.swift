//
//  JSONHelper.swift
//  Test_Cours_listUI
//
//  Created by m1 on 22/02/2022.
//

import Foundation

enum JSONError: Error, CustomStringConvertible {
    case FILE_NOT_FOUND(String)
    case JSON_DECODING_FAILED
    case JSON_ENCODING_FAILED
    case INIT_DATA_FAILED
    case UNKNOWN
    
    var description: String {
        switch self {
            case .FILE_NOT_FOUND(let filename): return "File \(filename) could not be found"
            case .JSON_DECODING_FAILED: return "JSON decoding failed"
            case .JSON_ENCODING_FAILED: return "JSON encoding failed"
            case .INIT_DATA_FAILED: return "Bad data format: Initialization of data failed"
            case .UNKNOWN: return "Unknown error during JSON parsing"
        }
    }
}

struct JSONHelper {
    static func loadFomFile(name: String, ext: String) -> Result<Data, JSONError>{
        if let fileURL = Bundle.main.url(forResource: name, withExtension: ext){
            do {
                let data = try Data(contentsOf: fileURL)
                return .success(data)
            } catch {
                return .failure(.INIT_DATA_FAILED)
            }
        } else {
            return .failure(.FILE_NOT_FOUND(name + "." + ext))
        }
    }
    
    static func decode<T: Decodable>(data: Data) -> Result<T, JSONError> {
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode(T.self, from: data){
            return .success(decoded)
        } else {
            return .failure(.JSON_DECODING_FAILED)
        }
    }
}
