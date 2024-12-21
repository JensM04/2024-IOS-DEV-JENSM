import SwiftUI
import Firebase
import FirebaseAuth

struct ContentView: View {
    @State private var email = ""
    @State private var password = ""
    var body: some View {
        ZStack{
            Color.white
            
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(.linearGradient(colors: [.pink, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width:1000, height: 400)
                .rotationEffect(.degrees(135))
                .offset(y: -600)
            
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(.linearGradient(colors: [.white, .white], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width:1000, height: 7)
                .rotationEffect(.degrees(135))
                .offset(y: -350)
            
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(.linearGradient(colors: [.pink, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width:1000, height: 400)
                .rotationEffect(.degrees(135))
                .offset(y: 600)
            
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(.linearGradient(colors: [.white, .white], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width:1000, height: 7)
                .rotationEffect(.degrees(135))
                .offset(y: 350)
            
            VStack(spacing: 20){
                TextField("Email", text: $email)
                    .foregroundColor(.black)
                    .textFieldStyle(.plain)
                    .placeholder(when: email.isEmpty){
                        Text("Email").foregroundColor(.white)
                            .bold()
                    }
                
                Rectangle().frame(width: 350, height: 1)
                    .foregroundColor(.black)
                
                
                SecureField("Password", text: $password)
                    .foregroundColor(.black)
                    .textFieldStyle(.plain)
                    .placeholder(when: password.isEmpty){
                        Text("Password").foregroundColor(.white)
                            .bold()
                    }
                
                Rectangle().frame(width: 350, height: 1)
                    .foregroundColor(.black)
                
                HStack(spacing: 20) {
                    Button {
                        register()
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
                        login()
                    } label: {
                        Text("Log in")
                            .bold()
                            .frame(width: 150, height: 40) // Adjust width to fit better
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
    
    func register(){
        Auth.auth().createUser(withEmail: email, password: password){
            result, error in if error != nil {
                print(error!.localizedDescription)
                //todo betere errorhandling
            }
        }
    }
    
    //todo andere ui voor login
    func login(){
        Auth.auth().signIn(withEmail: email, password: password){
            result, error in if error != nil {
            print(error!.localizedDescription)
            //todo betere errorhandling
        }
    }
    }
}

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

#Preview {
    ContentView()
}
