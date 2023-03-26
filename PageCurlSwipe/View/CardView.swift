//
//  CardView.swift
//  PageCurlSwipe
//
//  Created by Quang Bao on 25/03/2023.
//

import SwiftUI

struct CardView: View {
    
    var image: ImageModel
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            ZStack {
                Image(image.assetName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipShape(RoundedRectangle(cornerRadius: 10,
                                                style: .continuous))
            }
        }
        .frame(height: 130)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(image: ImageModel(assetName: "img_1"))
    }
}
