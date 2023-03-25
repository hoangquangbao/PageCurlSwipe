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
                    /* Making it look like it's rolling */
                        .shadow(color: .black.opacity(dragProgress != 0 ? 0.1 : 0),
                                radius: 5,
                                x: 15,
                                y: 0)
                        .overlay(content: {
                            Rectangle()
                                .fill(.white.opacity(0.25))
                                .mask(content)
                        })
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
        /* Background shadow */
            .background {
                GeometryReader {
                    let rect = $0.frame(in: .global)
                    
                    Rectangle()
                        .fill(.black)
                    /*
                     - When we added the vertical padding of 10 to the delete view, you can see that the backdrop shadow is greater than it is in the delete view. Keep in mind that adding padding vertically by 10 will not fix the issue; since the shadow radius is 15, we must also take that into account and padding vertically by a total of 25 (15 + 10) instead.
                     */
                        .padding(.vertical, 25)
                        .shadow(color: .black.opacity(0.3),
                                radius: 15,
                                x: 30,
                                y: 0)
                    /* To make the shadow visible, move the rectangle along with the gesture progress. */
                    // Moving along side along dragging
                        .padding(.trailing, rect.width * dragProgress)
                }
                .mask(content)
            }
            .background {
                RoundedRectangle(cornerRadius: 15, style: .continuous)
                    .fill(.red.gradient)
                    .overlay(alignment: .trailing) {
                        Image(systemName: "trash")
                            .font(.title)
                            .padding(.trailing, 20)
                            .foregroundColor(.white)
                    }
                    .padding(.vertical, 10)
            }
    }
}

struct PeelEffectView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
