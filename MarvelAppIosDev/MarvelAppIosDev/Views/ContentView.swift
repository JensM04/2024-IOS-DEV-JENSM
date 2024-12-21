import SwiftUI
import Firebase
import FirebaseAuth

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    
    @State private var userIsLoggedIn = false
    @StateObject private var sessionManager = UserSessionManager()
    @State private var errorMessage = ""
    
    @Environment(\.colorScheme) var colorScheme
    
    //als gebruiker ingelogd is -> navigate to CharactersView, anders blijf op loginView
    var body: some View {
         NavigationView {
             if sessionManager.isLoggedIn {
                 CharactersView()
             } else {
                 loginView
             }
         }
         .environmentObject(sessionManager)
         .alert(isPresented: .constant(!errorMessage.isEmpty)) {
             Alert(
                 title: Text("Error ❌"),
                 message: Text(errorMessage),
                 dismissButton: .default(Text("Try again")) {
                     errorMessage = ""
                 }
             )
         }
     }
    
    //loginview
    var loginView: some View {
        ZStack {
            //achtergrond
            Color(colorScheme == .dark ? .black : .white)
                .ignoresSafeArea()
            
            //ui
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(.linearGradient(colors: [.pink, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 1000, height: 400)
                .rotationEffect(.degrees(135))
                .offset(y: -600)
            
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(
                    .linearGradient(
                        colors: colorScheme == .dark ? [.black, .black] : [.white, .white],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 1000, height: 7)
                .rotationEffect(.degrees(135))
                .offset(y: -350)
            
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(.linearGradient(colors: [.pink, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 1000, height: 400)
                .rotationEffect(.degrees(135))
                .offset(y: 600)
            
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(
                    .linearGradient(
                        colors: colorScheme == .dark ? [.black, .black] : [.white, .white],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 1000, height: 7)
                .rotationEffect(.degrees(135))
                .offset(y: 350)
            
            VStack(spacing: 20) {
                //email textfield
                TextField("Email", text: $email)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                    .textFieldStyle(.plain)
                    .placeholder(when: email.isEmpty) {
                        Text("Email").foregroundColor(.white)
                            .bold()
                    }
                
                //ui
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                
                //wachtwoord textfield
                ZStack {
                    //als boolean true -> normaal textfield (visible text)
                    if isPasswordVisible {
                        TextField("Password", text: $password)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .textFieldStyle(.plain)
                            .placeholder(when: password.isEmpty) {
                                Text("Password").foregroundColor(.white)
                                    .bold()
                            }
                    } else {
                        //als boolean false -> securefield (invisible text)
                        SecureField("Password", text: $password)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                            .textFieldStyle(.plain)
                            .placeholder(when: password.isEmpty) {
                                Text("Password").foregroundColor(.white)
                                    .bold()
                            }
                    }
                    
                    //eye button voor passwoord
                    HStack {
                        Spacer()
                        Button(action: {
                            isPasswordVisible.toggle()
                        }) {
                            Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.trailing, 10)
                }
                
                //ui
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(colorScheme == .dark ? .white : .black)
                
                //knoppen, horizontaal met spacing
                HStack(spacing: 20) {
                    Button {
                        sessionManager.register(email: email, password: password) { result in
                            switch result {
                            case .success:
                                errorMessage = ""
                            case .failure(let error):
                                errorMessage = error.localizedDescription
                            }
                        }
                    } label: {
                        Text("Sign up")
                            .bold()
                            .frame(width: 150, height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(.linearGradient(colors: [.pink, .red], startPoint: .top, endPoint: .bottomTrailing))
                            )
                            .foregroundColor(.white)
                    }

                    Button {
                        sessionManager.login(email: email, password: password) { result in
                            switch result {
                            case .success:
                                errorMessage = ""
                            case .failure(let error):
                                errorMessage = error.localizedDescription
                            }
                        }
                    } label: {
                        Text("Log in")
                            .bold()
                            .frame(width: 150, height: 40)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(.linearGradient(colors: [.pink, .red], startPoint: .top, endPoint: .bottomTrailing))
                            )
                            .foregroundColor(.white)
                    }
                }
                .padding(.top)
            }
            .frame(width: 350)
        }
        .ignoresSafeArea()
    }
}


//custom ui voor textfields
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

//voor de preview
#Preview {
    ContentView()
}
