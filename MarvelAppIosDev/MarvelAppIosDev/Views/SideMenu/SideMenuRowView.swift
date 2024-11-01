//
//  SideMenuRowView.swift
//  MarvelAppIosDev
//
//  Created by Jens meersschaert on 28/09/2024.
//

import SwiftUI

struct SideMenuRowView: View {
    let option: SideMenuOptionModel
    @Binding var selectedOption: SideMenuOptionModel?
    
    private var isSelected: Bool {
        selectedOption == option    
    }
    
    var body: some View {
        HStack{
            Image(systemName: option.ImageName)
                .imageScale(.small)
            
            Text(option.title)
                .font(.subheadline)
            
            Spacer()
        }
        .padding(.leading)
        .foregroundStyle(isSelected ? .red : .primary)
        .frame(width: 216, height: 44)
        .background(isSelected ? .red.opacity(0.15) : .clear)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    SideMenuRowView(option: .characters, selectedOption: .constant(.characters))
}
