//
//  Home.swift
//  PageCurlSwipe
//
//  Created by Quang Bao on 25/03/2023.
//

import SwiftUI

struct Home: View {
    
    @State private var images: [ImageModel] = []
    
    var body: some View {
        
        ZStack {
            if images.isEmpty {
                ProgressView()
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 15) {
                        ForEach(images) { image in
                            PeelEffectView {
                                CardView(image: image)
                            } onDelete: {
                                /// Deleting the CardView
                                if let index = images.firstIndex(where: {
                                    $0.id == image.id
                                }) {
                                    let _ = withAnimation(.spring(response: 0.6,
                                                          dampingFraction: 0.7,
                                                          blendDuration: 0.7)) {
                                        images.remove(at: index)
                                    }
                                }
                            }
                        }
                    }
                    .padding(15)
                }
            }
        }
        .onAppear {
            Task {
                for index in 1...8 {
                    images.append(.init(assetName: "img_\(index)"))
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
