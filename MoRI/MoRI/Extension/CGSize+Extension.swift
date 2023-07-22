//
//  CGSize.swift
//  MoRI
//
//  Created by Ko Seokjun on 2023/07/21.
//

import Foundation

extension CGSize {
  static func + (left: Self, right: Self) -> Self {
    CGSize(width: left.width + right.width, height: left.height + right.height)
  }
}
