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
    @State private var isExpanded: Bool = false
    
    init(@ViewBuilder content: @escaping () -> Content,
         onDelete: @escaping () -> Void) {
        self.content = content()
        self.onDelete = onDelete
    }
    
    var body: some View {
        content
            .hidden()
            .overlay(content: {
                GeometryReader {
                    let rect = $0.frame(in: .global)
                    
                    /* Background view */
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .fill(.red.gradient)
                        .overlay(alignment: .trailing) {
                            Button {
                                print("Tapping..")
                            } label: {
                                Image(systemName: "trash")
                                    .font(.title)
                                    .padding(.trailing, 20)
                                    .foregroundColor(.white)
                            }
                            .disabled(!isExpanded)
                        }
                        .padding(.vertical, 10)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture()
                                .onChanged({ value in
                                    /* The Draggesture is still activate, disable it when card is peeled */
                                    ///Disabling the Gesture when it's expanded
                                    guard !isExpanded else { return }
                                    /* Right to Left Swipe: Negative value */
                                    var translationX = value.translation.width
                                    /* Limiting to Max: Zero */
                                    translationX = max(-translationX, 0)
                                    /* Converting translation into progress (0 - 1) */
                                    let progress = min(1, translationX / rect.width)
                                    dragProgress = progress
                                })
                                .onEnded({ value in
                                    ///Disabling the Gesture when it's expanded
                                    guard !isExpanded else { return }
                                    /* Smooth ending animation */
                                    withAnimation(.spring(response: 0.6,
                                                          dampingFraction: 0.7,
                                                          blendDuration: 0.7)) {
                                        if dragProgress > 0.25 {
                                            /* Keep the drag gesture */
                                            dragProgress = CGFloat.random(in: 0.4...0.7)
                                            isExpanded = true
                                        } else {
                                            dragProgress = .zero
                                            isExpanded = false
                                        }
                                    }
                                })
                        )
                    /* If we tap other than Delete button, it will reset to init state */
                        .onTapGesture {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                dragProgress = .zero
                                isExpanded = false
                            }
                        }
                    
                    /* Background shadow */
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
                    /// Moving along side while dragging
                        .padding(.trailing, rect.width * dragProgress)
                        .mask(content)
                    /// Disable Interaction
                        .allowsHitTesting(false)
                    
                    content
                        .mask {
                            Rectangle()
                            /* Masking original content */
                            /*
                             - Swipe: Right to Left
                             - Thus masking from right to left (trailing)
                             - When the user starts dragging, the content start hiding from right to left, that's why we applied padding on the trailing side.
                             */
                                .padding(.trailing, dragProgress * rect.width)
                        }
                    /* Disable Interaction */
                        .allowsHitTesting(false)
                }
            })
        
            .overlay {
                GeometryReader {
                    let size = $0.size
                    let minOpacity = dragProgress / 0.05
                    let opacity = min(1, minOpacity)
                    
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
                    /* Making it glow at the back side */
                        .overlay(alignment: .trailing) {
                            Rectangle()
                                .fill(
                                    .linearGradient(
                                        colors: [.clear,
                                                 .white,
                                                 .clear,
                                                 .clear],
                                        startPoint: .leading,
                                        endPoint: .trailing)
                                )
                                .frame(width: 60)
                                .offset(x: 40)
                            /* The glow gradient can still be seen at the idle, but it can be removed with the help of progress from the drag gesture */
                                .offset(x: -30 + (30 * opacity))
                            /* Moving along side while dragging */
                                .offset(x: size.width * -dragProgress)
                        }
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
                }
                /* Disable Interaction */
                .allowsHitTesting(false)
            }
    }
}

struct PeelEffectView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
