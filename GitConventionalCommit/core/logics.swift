//
//  logics.swift
//  GitConventionalCommit
//
//  Created by Devalla Bharath on 1/6/25.
//

import SwiftUI

func getCommitMsg(_ url: URL) -> (String, Bool) {
  if url.isFileURL {
    let fileManager = FileManager.default
    if fileManager.fileExists(atPath: url.path) {
      do {
        let msg = try String(contentsOf: url, encoding: .utf8)
        return (msg, false)
      } catch {
        return ("Error reading file \(url.path)", true)
      }
    } else {
      return ("No file found at \(url.path)", true)
    }
  } else {
    return ("Not a file url", true)
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

// get body start & end line

// parse git status
