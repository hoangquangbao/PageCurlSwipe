//
//  PeelEffectView.swift
//  PageCurlSwipe
//
//  Created by Quang Bao on 25/03/2023.
//

import SwiftUI

/* Custom View Builder*/
struct PeelEffectView<Content: View>: View {
    
    var content: Content
    /* Delete callback for MainView when Delete is clicked*/
    var onDelete: () -> ()
    
    init(@ViewBuilder content: @escaping () -> Content,
         onDelete: @escaping () -> Void) {
        self.content = content()
        self.onDelete = onDelete
    }
    
    var body: some View {
        content
    }
}

struct PeelEffectView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
