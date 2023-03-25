//
//  PeelEffectView.swift
//  PageCurlSwipe
//
//  Created by Quang Bao on 25/03/2023.
//

import SwiftUI

/* Custom View Builder */
struct PeelEffectView<Content: View>: View {
    
    var content: Content
    /* Delete callback for MainView when Delete is clicked */
    var onDelete: () -> ()
    
    /* View properties */
    @State private var dragProgress: CGFloat = 0
    
    init(@ViewBuilder content: @escaping () -> Content,
         onDelete: @escaping () -> Void) {
        self.content = content()
        self.onDelete = onDelete
    }
    
    var body: some View {
        content
        /* Masking original conten */
            .mask({
                GeometryReader {
                    let rect = $0.frame(in: .global)
                    

                    Rectangle()
                    /*
                     - Swipe: Right to Left
                     - Thus masking from right to left (trailing)
                     - When the user starts dragging, the content start hiding from right to left, that's why we applied padding on the trailing side.
                     */
                        .padding(.trailing, dragProgress * rect.width)
                }
            })
            .overlay {
                GeometryReader {
                    let rect = $0.frame(in: .global)
                    let size = $0.size
                    
                    content
                    /*
                     - Flipping horizontally for upsize image
                     - Since the masking starts from right to left, we flip the overlay horizontally to match the masking effect
                     */
                        .scaleEffect(x: -1)
                    
                    /* Since we place an ovelay, the masking is not visible, so we need to move the overlay to its rightmost extent and move along with the gesture progress. This allows us to see both the masking and the overlay
                     */
                    /* Moving along side while dragging */
                        .offset(x: size.width - (size.width * dragProgress))
                    /* Overscrolling the overlay will make it move more quickly than deffault masking effect */
                        .offset(x: size.width * -dragProgress)
                    /* Masking overlayed image for removing outbound visibilty */
                        .mask({
                            Rectangle()
                                .offset(x: size.width * -dragProgress)
                        })
                        .contentShape(Rectangle())
                    
                        .gesture(
                            DragGesture()
                                .onChanged({ value in
                                    /* Right to Left Swipe: Negative value */
                                    var translationX = value.translation.width
                                    /* Limiting to Max: Zero */
                                    translationX = max(-translationX, 0)
                                    /* Converting translation into progress (0 - 1) */
                                    let progress = min(1, translationX / size.width)
                                    dragProgress = progress
                                })
                                .onEnded({ value in
                                    /* Smooth ending animation */
                                    withAnimation(.spring(response: 0.6,
                                                          dampingFraction: 0.7,
                                                          blendDuration: 0.7)) {
                                        dragProgress = .zero
                                    }
                                })
                        )
                }
            }
    }
}

struct PeelEffectView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
