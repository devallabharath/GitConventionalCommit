//
//  logics.swift
//  GitConventionalCommit
//
//  Created by Devalla Bharath on 1/6/25.
//

import SwiftUI

func getCommitMsg(_ url: URL) -> String{
  let fileManager = FileManager.default
  if fileManager.fileExists(atPath: url.path) {
    do {
      return try String(contentsOf: url, encoding: .utf8)
    } catch {
      return "Error reading file \(url.path)\n\(error)"
    }
  } else {
    return "No file found at \(url.path)"
  }
}

func writeCommitMsg(_ msg: String, _ url: URL) -> Error? {
  do {
    try msg.write(toFile: url.path, atomically: true, encoding: .utf8)
    return nil
  } catch {
    return error
  }
}

// is comment line

// get subject line
