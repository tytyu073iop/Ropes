import SwiftUI
struct AddButtonConfig: ButtonStyle{
    func makeBody(configuration: Configuration) -> some View {
        ZStack{
            configuration.label
            withAnimation(.easeInOut(duration: 0.1)) {
                HStack {
                    Spacer()
                    Image(systemName: "checkmark.circle")
                }
                .opacity(configuration.isPressed ? 1 : 0)
            }
        }
        .padding(5)
        .background(.gray)
        .cornerRadius(15.0)
    }
}
