//
//  SideMenuView.swift
//  MarvelAppIosDev
//
//  Created by Jens meersschaert on 28/09/2024.
//

import SwiftUI

struct SideMenuView: View {
    @Binding var isShowing: Bool
    @Binding var selectedTab: Int
    @State private var selectedOption: SideMenuOptionModel?
    @EnvironmentObject var sessionManager: UserSessionManager

    @Environment(\.colorScheme) var colorScheme
    
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
                                    onOptionTapped(option)
                                }, label: {
                                    SideMenuRowView(option: option, selectedOption: $selectedOption)
                                })
                            }
                        }
                        
                        Spacer()
                        
                        //logout button die gebruikt maakt van sessionmanager
                        Button(action: {
                            sessionManager.logout()
                            isShowing = false
                        }) {
                            HStack {
                                Image(systemName: "arrow.backward.square")
                                    .foregroundColor(.red)
                                    .font(.headline)
                                Text("Logout")
                                    .foregroundColor(.red)
                                    .bold()
                            }
                            .padding()
                        }
                    }
                    .padding()
                    .frame(width: 270, alignment: .leading)
                    .background(
                        colorScheme == .dark ? Color.black : Color.white
                    )
                    Spacer()
                }.transition(.move(edge: .leading))
                
            }
        }
        .animation(.easeInOut, value: isShowing)
    }
    
    private func onOptionTapped(_ option: SideMenuOptionModel) {
        selectedOption = option
        selectedTab = option.rawValue
        isShowing = false
    }
}

#Preview {
    SideMenuView(isShowing: .constant(true),selectedTab: .constant(0))
}
