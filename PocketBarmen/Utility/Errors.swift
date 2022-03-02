//
//  Errors.swift
//  PocketBarmen
//
//  Created by Oguzhan Ozturk on 9.09.2021.
//

import Foundation

enum NetworkServiceError : Error{
    case NetworkError , ServerError , DataNotValid , DataParsingError
}

enum DatabaseError : Error{
    case DataExists , WriteError , ReadError , DeleteError , DataNotFound
}
