//
//  LoadingView.swift
//  Test_Cours_listUI
//
//  Created by m1 on 22/02/2022.
//

import SwiftUI

extension View {
    func loadingDialog(isShowing: Binding<Bool>, message: String) -> some View{
        self.fullScreenCover(isPresented: isShowing){
            HStack(spacing: 10) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                Text(message)
            }.background(Color.white.opacity(0.3))
        }
    }
}
