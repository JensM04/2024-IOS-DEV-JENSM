import SwiftUI
import Firebase
import FirebaseAuth

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isPasswordVisible = false
    @State private var errorMessage = ""
    @StateObject private var sessionManager = UserSessionManager()

    @Environment(\.colorScheme) var colorScheme
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.verticalSizeClass) var verticalSizeClass

    var body: some View {
        NavigationStack {
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

    var loginView: some View {
        ZStack {
            Color(colorScheme == .dark ? .black : .white)
                .ignoresSafeArea()

            //geen rode ui voor ipad
            if UIDevice.current.userInterfaceIdiom == .pad {
                VStack(spacing: 30) {
                    emailTextField
                    passwordTextField
                    actionButtons
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 40)
            } else {
                redRectangles
                
                VStack(spacing: 20) {
                    emailTextField
                    passwordTextField
                    actionButtons
                }
                .frame(width: 350)
            }
        }
        .ignoresSafeArea()
    }

    var redRectangles: some View {
        Group {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(.linearGradient(colors: [.pink, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 1000, height: 400)
                .rotationEffect(.degrees(135))
                .offset(y: -600)

            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(.linearGradient(colors: colorScheme == .dark ? [.black, .black] : [.white, .white], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 1000, height: 7)
                .rotationEffect(.degrees(135))
                .offset(y: -350)

            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(.linearGradient(colors: [.pink, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 1000, height: 400)
                .rotationEffect(.degrees(135))
                .offset(y: 600)

            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(.linearGradient(colors: colorScheme == .dark ? [.black, .black] : [.white, .white], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 1000, height: 7)
                .rotationEffect(.degrees(135))
                .offset(y: 350)
        }
    }

    var emailTextField: some View {
        VStack {
            TextField("Email", text: $email)
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .textFieldStyle(.plain)
                .placeholder(when: email.isEmpty) {
                    Text("Email").foregroundColor(.white).bold()
                }

            Rectangle()
                .frame(height: 1)
                .foregroundColor(colorScheme == .dark ? .white : .black)
        }
    }

    var passwordTextField: some View {
        VStack {
            ZStack {
                if isPasswordVisible {
                    TextField("Password", text: $password)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .textFieldStyle(.plain)
                        .placeholder(when: password.isEmpty) {
                            Text("Password").foregroundColor(.white).bold()
                        }
                } else {
                    SecureField("Password", text: $password)
                        .foregroundColor(colorScheme == .dark ? .white : .black)
                        .textFieldStyle(.plain)
                        .placeholder(when: password.isEmpty) {
                            Text("Password").foregroundColor(.white).bold()
                        }
                }

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

            Rectangle()
                .frame(height: 1)
                .foregroundColor(colorScheme == .dark ? .white : .black)
        }
    }

    var actionButtons: some View {
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
                    .frame(width: 200, height: 50)
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
                    .frame(width: 200, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .fill(.linearGradient(colors: [.pink, .red], startPoint: .top, endPoint: .bottomTrailing))
                    )
                    .foregroundColor(.white)
            }
        }
        .padding(.top)
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
