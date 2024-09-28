//
//  SideMenuRowView.swift
//  MarvelAppIosDev
//
//  Created by Jens meersschaert on 28/09/2024.
//

import SwiftUI

struct SideMenuRowView: View {
    let option: SideMenuOptionModel
    var body: some View {
        HStack{
            Image(systemName: option.ImageName)
                .imageScale(.small)
            
            Text(option.title)
                .font(.subheadline)
            
            Spacer()
        }
        .padding(.leading)
        .frame(height: 44)
    }
}

#Preview {
    SideMenuRowView(option: .characters)
}
