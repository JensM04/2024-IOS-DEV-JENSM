//
//  SideMenuHeaderView.swift
//  MarvelAppIosDev
//
//  Created by Jens meersschaert on 28/09/2024.
//

import SwiftUI

struct SideMenuHeaderView: View {
    var body: some View {
        HStack{
            Image(systemName: "person.circle.fill")
                .imageScale(.large)
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(.red)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.vertical)
            
            VStack(alignment: .leading, spacing: 6){
                Text("Marvel app")
                    .font(.headline)
                Text("Made by Jens")
                    .font(.footnote)
                    .tint(.gray)
            }
        }
        

    }
}

#Preview {
    SideMenuHeaderView()
}
