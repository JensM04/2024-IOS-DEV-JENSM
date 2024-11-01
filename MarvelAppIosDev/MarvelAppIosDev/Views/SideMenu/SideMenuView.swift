//
//  SideMenuView.swift
//  MarvelAppIosDev
//
//  Created by Jens meersschaert on 28/09/2024.
//

import SwiftUI

struct SideMenuView: View {
    @Binding var isShowing: Bool
    @State private var selectedOption: SideMenuOptionModel?
    
    var body: some View {
        ZStack{
            if isShowing{
                Rectangle().opacity(0.3).ignoresSafeArea().onTapGesture {
                    isShowing.toggle()
                }
                
                HStack{
                    VStack(alignment: .leading, spacing: 32){
                        SideMenuHeaderView()
                        
                        VStack {
                            ForEach(SideMenuOptionModel.allCases){ option in
                                Button(action: {
                                    selectedOption = option
                                }, label: {
                                    SideMenuRowView(option: option, selectedOption: $selectedOption)
                                })
                            }
                        }
                        
                        Spacer()
                    }
                    .padding()
                    .frame(width: 270, alignment: .leading)
                    .background(.white)
                    Spacer()
                }
                
            }
        }
        .transition(.move(edge: .leading))
        .animation(.easeInOut, value: isShowing)
    }
}

#Preview {
    SideMenuView(isShowing: .constant(true))
}
