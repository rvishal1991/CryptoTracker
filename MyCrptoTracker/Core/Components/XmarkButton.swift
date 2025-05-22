//
//  XmarkButton.swift
//  MyCrptoTracker
//
//  Created by apple on 22/05/25.
//

import SwiftUI
import SwiftfulRouting

struct XmarkButton: View {
   
    @Environment(\.router) var router

    var body: some View {
        Button {
            router.dismissScreen()
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
        }
    }
}

#Preview {
    XmarkButton()
}
