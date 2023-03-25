//
//  ImageModel.swift
//  PageCurlSwipe
//
//  Created by Quang Bao on 25/03/2023.
//

import SwiftUI

/***
 The Scrollview uses this model to show a list of the photos that are available in the Assets.
 */
struct ImageModel: Identifiable {
    var id: UUID = .init()
    var assetName: String
}
