//
//  ContentView.swift
//  PageCurlSwipe
//
//  Created by Quang Bao on 25/03/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            Home()
                .navigationTitle("Peel Effect")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
