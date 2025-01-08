//
//  logics.swift
//  GitConventionalCommit
//
//  Created by Devalla Bharath on 1/6/25.
//

import SwiftUI

func getCommitMsg(_ url: URL) -> String {
  var msg: String

  if url.isFileURL {
    let fileManager = FileManager.default
    if fileManager.fileExists(atPath: url.path) {
      do {
        msg = try String(contentsOf: url, encoding: .utf8)
      } catch {
        msg = "\(error)"
        print("Error reading file: \(error)")
      }
    } else {
      msg = "No file found at \(url.path)"
      print("No file found at \(url.path)")
    }
  } else {
    msg = "Not a file url"
  }

  return msg
}

// is comment line

// get subject line

// get body start & end line

// parse git status
